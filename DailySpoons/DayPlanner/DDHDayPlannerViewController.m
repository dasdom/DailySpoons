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

@interface DDHDayPlannerViewController () <UICollectionViewDelegate>
@property (nonatomic, weak) id<DDHDayPlannerViewControllerProtocol> delegate;
@property (nonatomic, strong) DDHDataStore *dataStore;
@property (nonatomic, strong) UICollectionViewDiffableDataSource *dataSource;
@property (nonatomic, weak) UILabel *spoonsAmountLabel;
@end

@implementation DDHDayPlannerViewController

- (instancetype)initWithDelegate:(id<DDHDayPlannerViewControllerProtocol>)delegate dataStore:(DDHDataStore *)dataStore {
  if (self = [super init]) {
    _delegate = delegate;
    _dataStore = dataStore;
  }
  return self;
}

- (void)loadView {
  DDHDayPlannerView *contentView = [[DDHDayPlannerView alloc] init];
  [self setView:contentView];
}

- (DDHDayPlannerView *)contentView {
  return (DDHDayPlannerView *)[self view];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.counterclockwise"] style:UIBarButtonItemStylePlain target:self action:@selector(reset:)];
  [[self navigationItem] setRightBarButtonItem:resetButton];

  [self setupCollectionView];
  [self updateWithDay:[[self dataStore] day]];
}

- (void)setupCollectionView {
  UICollectionView *collectionView = [[self contentView] collectionView];
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
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath section] == 1) {
    NSUUID *actionId = [[self dataSource] itemIdentifierForIndexPath:indexPath];
    DDHAction *action = [[self dataStore] actionForId:actionId];
    DDHDay *day = [[self dataStore] day];
    DDHActionState actionState = [day actionStateForAction:action];
    if (actionState == DDHActionStateCompleted) {
      [day unCompleteAction:action];
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
    footerString = [NSString stringWithFormat:@"(%ld - %ld) / %ld", [day availableSpoons], [day carryOverSpoons], [day amountOfSpoons]];
  } else {
    footerString = [NSString stringWithFormat:@"%ld / %ld", [day availableSpoons], [day amountOfSpoons]];
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

  NSDiffableDataSourceSnapshot *snapshot = [[self dataSource] snapshot];
  [snapshot reconfigureItemsWithIdentifiers:[snapshot itemIdentifiers]];
  [[self dataSource] applySnapshot:snapshot animatingDifferences:YES];

  [self updateSpoonsAmount];
}

@end
