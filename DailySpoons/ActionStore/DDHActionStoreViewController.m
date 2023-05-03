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

NSString * const mainSection = @"mainSection";

@interface DDHActionStoreViewController () <UICollectionViewDelegate>
@property (nonatomic, weak) id<DDHActionStoreViewControllerProtocol> delegate;
@property (nonatomic, strong) UICollectionViewDiffableDataSource *dataSource;
@property (nonatomic, strong) DDHDataStore *dataStore;
@end

@implementation DDHActionStoreViewController
- (instancetype)initWithDelegate:(id<DDHActionStoreViewControllerProtocol>)delegate dataStore:(DDHDataStore *)dataStore {
  if (self = [super init]) {
    _delegate = delegate;
    _dataStore = dataStore;
  }
  return self;
}

- (void)loadView {
  DDHActionStoreView *contentView = [[DDHActionStoreView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:[self layout]];
  [self setView:contentView];
}

- (DDHActionStoreView *)contentView {
  return (DDHActionStoreView *)[self view];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setTitle:NSLocalizedString(@"Previous actions", nil)];

  UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
  [[self navigationItem] setRightBarButtonItem:addItem];

  [self setupCollectionView];
}

- (void)setupCollectionView {
  UICollectionView *collectionView = [[self contentView] collectionView];
  [collectionView setDelegate:self];

  [collectionView registerClass:[DDHActionCell class] forCellWithReuseIdentifier:[DDHActionCell identifier]];

  UICollectionViewCellRegistration *actionCellRegistration = [DDHCellRegistrationProvider actionCellRegistration:[self dataStore]];

  UICollectionViewDiffableDataSource *dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:actionCellRegistration forIndexPath:indexPath item:itemIdentifier];
  }];
  [self setDataSource:dataSource];

  NSArray<DDHAction *> *allActions = [[self dataStore] actions];
  [self updateWithActions:allActions];
}

- (void)updateWithActions:(NSArray<DDHAction *> *)actions {
  NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
  [snapshot appendSectionsWithIdentifiers:@[mainSection]];
  __block NSMutableArray<NSUUID *> *actionIds = [[NSMutableArray alloc] initWithCapacity:[actions count]];
  [actions enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [actionIds addObject:[action actionId]];
  }];
  [snapshot appendItemsWithIdentifiers:[actionIds copy] intoSectionWithIdentifier:mainSection];
  [[self dataSource] applySnapshot:snapshot animatingDifferences:true];
}

- (void)reload {
  NSDiffableDataSourceSnapshot *snapshot = [[self dataSource] snapshot];
  [snapshot reconfigureItemsWithIdentifiers:[snapshot itemIdentifiers]];
  [[self dataSource] applySnapshot:snapshot animatingDifferences:YES];
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSUUID *actionId = [[self dataSource] itemIdentifierForIndexPath:indexPath];
  DDHAction *action = [[self dataStore] actionForId:actionId];
  [[self delegate] addActionFromViewController:self action:action];
}

// MARK: - Actions
- (void)add:(UIBarButtonItem *)sender {
  [[self delegate] addSelectedInViewController:self];
}

// MARK: Layout
- (UICollectionViewLayout *)layout {
  UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
  [listConfiguration setTrailingSwipeActionsConfigurationProvider:^UISwipeActionsConfiguration * (NSIndexPath *indexPath) {
    return [UISwipeActionsConfiguration configurationWithActions:@[
      [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"Edit", nil) handler:^(UIContextualAction * _Nonnull contextualAction, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
      NSUUID *actionId = [[self dataSource] itemIdentifierForIndexPath:indexPath];
      DDHAction *action = [[self dataStore] actionForId:actionId];
      [[self delegate] editActionFromViewController:self action:action];
    }]
    ]];
  }];
  return [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
}
@end
