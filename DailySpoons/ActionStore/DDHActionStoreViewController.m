//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHActionStoreViewController.h"
#import "DDHActionStoreView.h"
#import "DDHDay.h"
#import "DDHCellRegistrationProvider.h"
#import "DDHDataStore.h"
#import "DDHAction.h"
#import "DDHActionCell.h"
#import "DDHActionStoreSection.h"
#import "DDHActionsHeaderView.h"

@interface DDHActionStoreViewController () <UICollectionViewDelegate, UISearchBarDelegate>
@property (nonatomic, weak) id<DDHActionStoreViewControllerProtocol> delegate;
@property (nonatomic, strong) UICollectionViewDiffableDataSource *dataSource;
@property (nonatomic, strong) id<DDHDataStoreProtocol> dataStore;
@property (nonatomic, strong) NSString *searchText;
@end

@implementation DDHActionStoreViewController
- (instancetype)initWithDelegate:(id<DDHActionStoreViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore {
  if (self = [super init]) {
    _delegate = delegate;
    _dataStore = dataStore;
  }
  return self;
}

- (void)setSearchText:(NSString *)searchText {
  _searchText = searchText;

  NSArray<DDHAction *> *allActions = self.dataStore.actions;
  [self updateWithActions:allActions];
}

- (void)loadView {
  DDHActionStoreView *contentView = [[DDHActionStoreView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:[self layout]];
  [contentView.searchBar setDelegate:self];
  self.view = contentView;
}

- (DDHActionStoreView *)contentView {
  return (DDHActionStoreView *)self.view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setTitle:NSLocalizedString(@"actionStore.title", nil)];

  UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
  self.navigationItem.rightBarButtonItem = addItem;

  [self setupCollectionView];
}

- (void)setupCollectionView {
  UICollectionView *collectionView = [self contentView].collectionView;
  collectionView.delegate = self;

  [collectionView registerClass:[DDHActionCell class] forCellWithReuseIdentifier:[DDHActionCell identifier]];
  [collectionView registerClass:[DDHActionsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[DDHActionsHeaderView identifier]];

  DDHDay *day = self.dataStore.day;

  UICollectionViewCellRegistration *actionCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[DDHActionCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
    DDHActionCell *actionCell = (DDHActionCell *)cell;
    DDHAction *action = [self.dataStore actionForId:item];
    DDHActionState actionState = [day actionStateForAction:action];
    BOOL isPlanned = [[day idsOfPlannedActions] containsObject:action.actionId];
    [actionCell updateWithAction:action isCompleted:(actionState == DDHActionStateCompleted) isPlanned:isPlanned];
  }];

  UICollectionViewDiffableDataSource *dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:actionCellRegistration forIndexPath:indexPath item:itemIdentifier];
  }];

  [dataSource setSupplementaryViewProvider:^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
    DDHActionsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[DDHActionsHeaderView identifier] forIndexPath:indexPath];
    headerView.addButton.hidden = YES;
    if ([indexPath section] == DDHActionStoreSectionUnplanned) {
      headerView.nameLabel.text = NSLocalizedString(@"actionStore.unplanned", nil);
    } else {
      headerView.nameLabel.text = NSLocalizedString(@"actionStore.planned", nil);
    }
    return headerView;
  }];

  self.dataSource = dataSource;

  [self updateWithActions:self.dataStore.actions];
}

- (void)updateWithActions:(NSArray<DDHAction *> *)actions {
  DDHDay *day = self.dataStore.day;

  NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
  [snapshot appendSectionsWithIdentifiers:@[
    [NSNumber numberWithInteger:DDHActionStoreSectionUnplanned],
    [NSNumber numberWithInteger:DDHActionStoreSectionPlanned]
  ]];
  __block NSMutableArray<NSUUID *> *plannedActionIds = [[NSMutableArray alloc] initWithCapacity:[actions count]];
  __block NSMutableArray<NSUUID *> *unplannedActionIds = [[NSMutableArray alloc] initWithCapacity:[actions count]];
  [actions enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    NSString *lowercaseSearchText = [self.searchText lowercaseString];
    BOOL shouldBeAdded = YES;
    if ([lowercaseSearchText length] > 0 && NO == [action.name.lowercaseString containsString:lowercaseSearchText]) {
      shouldBeAdded = NO;
    }
    if (shouldBeAdded) {
      NSUUID *actionId = action.actionId;
      if ([[day idsOfPlannedActions] containsObject:actionId]) {
        [plannedActionIds addObject:actionId];
      } else {
        [unplannedActionIds addObject:actionId];
      }
    }
  }];
  [snapshot appendItemsWithIdentifiers:[unplannedActionIds copy] intoSectionWithIdentifier:[NSNumber numberWithInteger:DDHActionStoreSectionUnplanned]];
  [snapshot appendItemsWithIdentifiers:[plannedActionIds copy] intoSectionWithIdentifier:[NSNumber numberWithInteger:DDHActionStoreSectionPlanned]];
  [self.dataSource applySnapshot:snapshot animatingDifferences:true];
}

- (void)reload {
  NSDiffableDataSourceSnapshot *snapshot = [self.dataSource snapshot];
  [snapshot reconfigureItemsWithIdentifiers:snapshot.itemIdentifiers];
  [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSUUID *actionId = [self.dataSource itemIdentifierForIndexPath:indexPath];
  if ([[self.dataStore.day idsOfPlannedActions] containsObject:actionId]) {
    return;
  }
  DDHAction *action = [self.dataStore actionForId:actionId];
  [self.delegate addActionFromViewController:self action:action];
}

// MARK: - Actions
- (void)add:(UIBarButtonItem *)sender {
  [self.delegate didSelectAddButtonInViewController:self name:self.searchText];
}

// MARK: Layout
- (UICollectionViewLayout *)layout {
  UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
  [listConfiguration setHeaderMode:UICollectionLayoutListHeaderModeSupplementary];
  [listConfiguration setTrailingSwipeActionsConfigurationProvider:^UISwipeActionsConfiguration * (NSIndexPath *indexPath) {

    NSUUID *actionId = [self.dataSource itemIdentifierForIndexPath:indexPath];
    DDHAction *action = [self.dataStore actionForId:actionId];

    NSMutableArray *contextualActions = [[NSMutableArray alloc] init];
    [contextualActions addObject:[self contextualEditActionWithAction:action]];

    DDHDay *day = self.dataStore.day;
    DDHActionState actionState = [day actionStateForAction:action];
    if (actionState == DDHActionStateNone) {
      [contextualActions addObject:[self contextualDeleteActionWithAction:action]];
    }

    return [UISwipeActionsConfiguration configurationWithActions: contextualActions];

  }];
  return [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
}

- (UIContextualAction *)contextualEditActionWithAction:(DDHAction *)action {
  return [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"actionStore.edit", nil) handler:^(UIContextualAction * _Nonnull contextualAction, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

    [self.delegate editActionFromViewController:self action:action];
    completionHandler(true);
  }];
}

- (UIContextualAction *)contextualDeleteActionWithAction:(DDHAction *)action {
  return [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:NSLocalizedString(@"actionStore.delete", nil) handler:^(UIContextualAction * _Nonnull contextualAction, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

    [self.dataStore removeAction:action];
    [self updateWithActions:self.dataStore.actions];
    [self.dataStore saveData];
    completionHandler(true);
  }];
}

// MARK: - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  [self setSearchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  if ([self.dataSource.snapshot.itemIdentifiers count] < 1) {
    [self add:nil];
  }
}
@end
