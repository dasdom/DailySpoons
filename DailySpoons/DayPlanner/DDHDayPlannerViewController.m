//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHDayPlannerViewController.h"
#import "DDHDayPlannerView.h"
#import "DDHDay.h"
#import "DDHDayPlannerSection.h"
#import "DDHSpoonCell.h"
#import "DDHActionCell.h"
#import "DDHDataStore.h"
#import "DDHSpoonsHeaderView.h"
#import "DDHSpoonsFooterView.h"
#import "DDHActionsHeaderView.h"
#import "DDHAction.h"
#import "DDHCellRegistrationProvider.h"
#import "NSUserDefaults+Helper.h"
#import "DDHSpoonsBackgroundView.h"

@interface DDHDayPlannerViewController () <UICollectionViewDelegate>
@property (nonatomic, weak) id<DDHDayPlannerViewControllerProtocol> delegate;
@property (nonatomic, strong) id<DDHDataStoreProtocol> dataStore;
@property (nonatomic, strong) UICollectionViewDiffableDataSource *dataSource;
@property (nonatomic, weak) UILabel *spoonsAmountLabel;
@end

@implementation DDHDayPlannerViewController

- (instancetype)initWithDelegate:(id<DDHDayPlannerViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore {
  if (self = [super init]) {
    _delegate = delegate;
    _dataStore = dataStore;
  }
  return self;
}

- (void)loadView {
  DDHDayPlannerView *contentView = [[DDHDayPlannerView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:[self layout]];
  [self setView:contentView];
}

- (DDHDayPlannerView *)contentView {
  return (DDHDayPlannerView *)[self view];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.counterclockwise"] style:UIBarButtonItemStylePlain target:self action:@selector(reset:)];
  [[self navigationItem] setRightBarButtonItem:resetButton];

  UICollectionView *collectionView = [[self contentView] collectionView];
  [self setupCollectionView:collectionView];
  [self updateWithDay:[[self dataStore] day]];

  UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  [collectionView addGestureRecognizer:longPressRecognizer];
}

- (void)setupCollectionView:(UICollectionView *)collectionView {
  [collectionView setDelegate:self];

  [collectionView registerClass:[DDHSpoonCell class] forCellWithReuseIdentifier:[DDHSpoonCell identifier]];
  [collectionView registerClass:[DDHActionCell class] forCellWithReuseIdentifier:[DDHActionCell identifier]];
  [collectionView registerClass:[DDHSpoonsHeaderView class] forSupplementaryViewOfKind:ELEMENT_KIND_SECTION_HEADER withReuseIdentifier:[DDHSpoonsHeaderView identifier]];
  [collectionView registerClass:[DDHSpoonsFooterView class] forSupplementaryViewOfKind:ELEMENT_KIND_SECTION_FOOTER withReuseIdentifier:[DDHSpoonsFooterView identifier]];
  [collectionView registerClass:[DDHActionsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[DDHActionsHeaderView identifier]];

  DDHDay *day = [[self dataStore] day];

  UICollectionViewCellRegistration *spoonCellRegistration = [DDHCellRegistrationProvider spoonCellRegistration:day];

  UICollectionViewCellRegistration *actionCellRegistration = [DDHCellRegistrationProvider actionCellRegistration:[self dataStore]];

  UICollectionViewDiffableDataSource *dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id _Nonnull itemIdentifier) {
    UICollectionViewCell *cell;
    switch ([indexPath section]) {
      case DDHDayPlannerSectionSpoons:
        cell = [collectionView dequeueConfiguredReusableCellWithRegistration:spoonCellRegistration forIndexPath:indexPath item:itemIdentifier];
        break;
      case DDHDayPlannerSectionActions:
        cell = [collectionView dequeueConfiguredReusableCellWithRegistration:actionCellRegistration forIndexPath:indexPath item:itemIdentifier];
        break;
    }
    return cell;
  }];
  [self setDataSource:dataSource];

  [dataSource setSupplementaryViewProvider:^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
    if ([indexPath section] == 0) {
      if ([elementKind isEqualToString:ELEMENT_KIND_SECTION_HEADER]) {
        DDHSpoonsHeaderView *spoonsHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[DDHSpoonsHeaderView identifier] forIndexPath:indexPath];
        return spoonsHeaderView;
      } else {
        DDHSpoonsFooterView *spoonsFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[DDHSpoonsFooterView identifier] forIndexPath:indexPath];
        [self setSpoonsAmountLabel:[spoonsFooterView label]];
        [self updateSpoonsAmount];
        return spoonsFooterView;
      }
    } else {
      DDHActionsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[DDHActionsHeaderView identifier] forIndexPath:indexPath];
      [[headerView addButton] removeTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
      [[headerView addButton] addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
      return headerView;
    }
  }];

  [[dataSource reorderingHandlers] setCanReorderItemHandler:^BOOL(id _Nonnull itemIdentifier) {
    return (NO == [[day spoonsIdentifiers] containsObject:itemIdentifier]);
  }];

  [[dataSource reorderingHandlers] setDidReorderHandler:^(NSDiffableDataSourceTransaction<NSNumber *, NSUUID *> * _Nonnull transaction) {
    NSInteger numberOfSpoons = [[day spoonsIdentifiers] count];
    NSInteger finalIndex = transaction.difference.insertions.firstObject.index - numberOfSpoons;
    NSInteger initialIndex = transaction.difference.insertions.firstObject.associatedIndex - numberOfSpoons;
    [day movePlannedActionFromIndex:initialIndex toFinalIndex:finalIndex];
    [[self dataStore] saveData];
  }];
}

- (void)updateWithDay:(DDHDay *)day {
  NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
  [snapshot appendSectionsWithIdentifiers:@[
    [NSNumber numberWithInteger:DDHDayPlannerSectionSpoons],
    [NSNumber numberWithInteger:DDHDayPlannerSectionActions]
  ]];
  [snapshot appendItemsWithIdentifiers:[day spoonsIdentifiers] intoSectionWithIdentifier:[NSNumber numberWithInteger:DDHDayPlannerSectionSpoons]];
  [snapshot appendItemsWithIdentifiers:[day idsOfPlannedActions] intoSectionWithIdentifier:[NSNumber numberWithInteger:DDHDayPlannerSectionActions]];
  [[self dataSource] applySnapshot:snapshot animatingDifferences:YES];
  [self updateSpoonsAmount];
}

- (void)reload {
  NSDiffableDataSourceSnapshot *snapshot = [[self dataSource] snapshot];
  [snapshot reconfigureItemsWithIdentifiers:[snapshot itemIdentifiers]];
  [[self dataSource] applySnapshot:snapshot animatingDifferences:YES];
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath section] == 1) {
    NSUUID *actionId = [[self dataSource] itemIdentifierForIndexPath:indexPath];
    DDHAction *action = [[self dataStore] actionForId:actionId];
    DDHDay *day = [[self dataStore] day];
    DDHActionState actionState = [day actionStateForAction:action];
    if (actionState == DDHActionStateCompleted) {
      [day uncompleteAction:action];
    } else {
      [day completeAction:action];
    }
    [[self dataStore] saveData];

    NSDiffableDataSourceSnapshot *snapshot = [[self dataSource] snapshot];
    [snapshot reconfigureItemsWithIdentifiers:[snapshot itemIdentifiers]];
    [[self dataSource] applySnapshot:snapshot animatingDifferences:YES];

    [self updateSpoonsAmount];
  }
}

- (void)updateSpoonsAmount {
  DDHDay *day = [[self dataStore] day];
  NSString *footerString;
  if ([day carryOverSpoons] > 0) {
    footerString = [NSString stringWithFormat:@"Planned: (%ld - %ld) / %ld\nCompleted: (%ld - %ld) / %ld", [day plannedSpoons], [day carryOverSpoons], [day amountOfSpoons], [day completedSpoons], [day carryOverSpoons], [day amountOfSpoons]];
  } else {
    footerString = [NSString stringWithFormat:@"Planned: %ld / %ld\nCompleted: %ld / %ld", [day plannedSpoons], [day amountOfSpoons], [day completedSpoons], [day amountOfSpoons]];
  }
  BOOL spoonDeficit = ([day plannedSpoons] - [day carryOverSpoons]) > [day amountOfSpoons];
  if (spoonDeficit) {
    [[self spoonsAmountLabel] setTextColor:[UIColor systemRedColor]];
  } else {
    [[self spoonsAmountLabel] setTextColor:[UIColor labelColor]];
  }
  [[self spoonsAmountLabel] setText:footerString];
}

// MARK: - Actions
- (void)add:(UIButton *)sender {
  [[self delegate] addSelectedInViewController:self];
}

- (void)reset:(UIBarButtonItem *)sender {
  DDHDay *day = [[self dataStore] day];
  [day resetWithDailySpoons:[[NSUserDefaults standardUserDefaults] dailySpoons]];

  [[self dataStore] saveData];

  [self updateWithDay:day];

  NSDiffableDataSourceSnapshot *snapshot = [[self dataSource] snapshot];
  [snapshot reconfigureItemsWithIdentifiers:[snapshot itemIdentifiers]];
  [[self dataSource] applySnapshot:snapshot animatingDifferences:YES];

  [self updateSpoonsAmount];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {

  UICollectionView *collectionView = [[self contentView] collectionView];

  switch ([sender state]) {
    case UIGestureRecognizerStateBegan:
    {
      NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:[sender locationInView:collectionView]];
      if (indexPath) {
        [collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
      }
    }
      break;
    case UIGestureRecognizerStateChanged:
      [collectionView updateInteractiveMovementTargetPosition:[sender locationInView:collectionView]];
      break;
    case UIGestureRecognizerStateEnded:
      [collectionView endInteractiveMovement];
      break;
    case UIGestureRecognizerStateCancelled:
      [collectionView cancelInteractiveMovement];
      break;
    default:
      break;
  }
}

// MARK - Layout
- (UICollectionViewLayout *)layout {

  UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {

    NSCollectionLayoutSection *section;

    if (sectionIndex == 0) {
      // Budget Section
      NSCollectionLayoutDimension *oneOverSixWidthDimension = [NSCollectionLayoutDimension fractionalWidthDimension:1.0/6.0];
      NSCollectionLayoutDimension *unityHeightDimension = [NSCollectionLayoutDimension fractionalHeightDimension:1.0];

      NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:oneOverSixWidthDimension heightDimension:unityHeightDimension];

      NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];

      NSCollectionLayoutDimension *unityWidthDimension = [NSCollectionLayoutDimension fractionalWidthDimension:1.0];

      NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:unityWidthDimension heightDimension:oneOverSixWidthDimension];

      NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];

      section = [NSCollectionLayoutSection sectionWithGroup:group];

      NSCollectionLayoutSize *headerFooterSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension estimatedDimension:30.0]];

      NSCollectionLayoutBoundarySupplementaryItem *sectionHeader = [NSCollectionLayoutBoundarySupplementaryItem boundarySupplementaryItemWithLayoutSize: headerFooterSize elementKind:ELEMENT_KIND_SECTION_HEADER alignment: NSRectAlignmentTop];

      NSCollectionLayoutBoundarySupplementaryItem *sectionFooter = [NSCollectionLayoutBoundarySupplementaryItem boundarySupplementaryItemWithLayoutSize: headerFooterSize elementKind:ELEMENT_KIND_SECTION_FOOTER alignment: NSRectAlignmentBottom];

      [section setBoundarySupplementaryItems: @[sectionHeader, sectionFooter]];

      NSCollectionLayoutDecorationItem *sectionBackground = [NSCollectionLayoutDecorationItem backgroundDecorationItemWithElementKind:ELEMENT_KIND_BACKGROUND];

      [section setDecorationItems: @[sectionBackground]];

      [section setContentInsets:NSDirectionalEdgeInsetsMake(0, 20, 0, 20)];

    } else if (sectionIndex == 1) {

      UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
      [listConfiguration setHeaderMode:UICollectionLayoutListHeaderModeSupplementary];
      [listConfiguration setTrailingSwipeActionsConfigurationProvider:^UISwipeActionsConfiguration * (NSIndexPath *indexPath) {
        return [UISwipeActionsConfiguration configurationWithActions:@[
          [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"Unplan", nil) handler:^(UIContextualAction * _Nonnull contextualAction, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
          NSUUID *actionId = [[self dataSource] itemIdentifierForIndexPath:indexPath];
          DDHAction *action = [[self dataStore] actionForId:actionId];
          DDHDay *day = [[self dataStore] day];
          [day unplanAction:action];
          [[self dataStore] saveData];
          [self updateWithDay:day];
        }],
          [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"Edit", nil) handler:^(UIContextualAction * _Nonnull contextualAction, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
          NSUUID *actionId = [[self dataSource] itemIdentifierForIndexPath:indexPath];
          DDHAction *action = [[self dataStore] actionForId:actionId];
          [[self delegate] editActionFromViewController:self action:action];
          completionHandler(true);
        }]
        ]];
      }];
      section = [NSCollectionLayoutSection sectionWithListConfiguration:listConfiguration layoutEnvironment:layoutEnvironment];
    }
    return section;
  }];

  [layout registerClass:[DDHSpoonsBackgroundView class] forDecorationViewOfKind:ELEMENT_KIND_BACKGROUND];

  return layout;
}

@end
