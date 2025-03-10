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
#import "DDHOnboardingOverlayView.h"
#import "DDHCollectionViewLayoutProvider.h"
#import "DDHHealthDataCell.h"
#import "DailySpoons-Swift.h"
#import <HealthKit/HealthKit.h>

@interface DDHDayPlannerViewController () <UICollectionViewDelegate>
@property (nonatomic, weak) id<DDHDayPlannerViewControllerProtocol> delegate;
@property (nonatomic, strong) id<DDHDataStoreProtocol> dataStore;
@property (nonatomic, strong) UICollectionViewDiffableDataSource *dataSource;
@property (nonatomic, weak) UILabel *spoonsAmountLabel;
@property (nonatomic, strong) DDHOnboardingOverlayView *overlayView;
@property (nonatomic, assign) DDHOnboardingState onboardingState;
@property (nonatomic, strong) HKHealthStore *healthStore;
@property (nonatomic) NSInteger stepsYesterday;
@property (nonatomic) NSInteger stepsToday;
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
  DDHDayPlannerView *contentView = [[DDHDayPlannerView alloc] initWithFrame:CGRectZero collectionViewLayout:[DDHCollectionViewLayoutProvider layoutWithTrailingSwipeActionsConfigurationProvider:^UISwipeActionsConfiguration * _Nullable(NSIndexPath * _Nonnull indexPath) {

    NSUUID *actionId = [self.dataSource itemIdentifierForIndexPath:indexPath];
    DDHAction *action = [self.dataStore actionForId:actionId];

    return [UISwipeActionsConfiguration configurationWithActions:@[[self contextualUnplanActionWithAction:action], [self contextualEditActionWithAction:action]]];
  } showSteps:[NSUserDefaults.standardUserDefaults showSteps]]];
  self.view = contentView;
}

- (DDHDayPlannerView *)contentView {
  return (DDHDayPlannerView *)self.view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.counterclockwise"] style:UIBarButtonItemStylePlain target:self action:@selector(reset:)];
  resetButton.accessibilityLabel = NSLocalizedString(@"dayPlanner.reset", nil);
  self.navigationItem.rightBarButtonItem = resetButton;

  UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectSettings:)];
  self.navigationItem.leftBarButtonItem = settingsButton;

  UICollectionView *collectionView = self.contentView.collectionView;
  [self setupCollectionView:collectionView];

  UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  [collectionView addGestureRecognizer:longPressRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self resetIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if (NO == [NSUserDefaults.standardUserDefaults onboardingShown]) {
    [self showOverlay];
  }
}

- (void)resetIfNeeded {
  DDHDay *day = self.dataStore.day;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  if (NO == [calendar isDate:day.date inSameDayAsDate:[NSDate now]]) {
    [day resetWithDailySpoons:[NSUserDefaults.standardUserDefaults dailySpoons]];
  }
  [self fetchStepsIfNeeded];
  [self updateWithDay:self.dataStore.day];
}

- (void)showOverlay {
  DDHDayPlannerView *contentView = [self contentView];
  _overlayView = [[DDHOnboardingOverlayView alloc] initWithFrame:contentView.frame];
  [[_overlayView nextButton] addTarget:self action:@selector(nextOnboarding:) forControlEvents:UIControlEventTouchUpInside];
  [contentView addSubview:_overlayView];

  [self nextOnboarding:nil];

  self.navigationController.navigationBar.userInteractionEnabled = NO;
  self.navigationController.navigationBar.accessibilityElementsHidden = YES;
  self.contentView.collectionView.userInteractionEnabled = NO;
  self.contentView.collectionView.accessibilityElementsHidden = YES;
}

- (void)nextOnboarding:(UIButton *)sender {
  DDHDayPlannerView *contentView = [self contentView];

  switch (self.onboardingState) {
    case DDHOnboardingStateSpoonBudget:
    {
      DDHSpoonsFooterView *spoonsFooterView = (DDHSpoonsFooterView *)[[self contentView].collectionView supplementaryViewForElementKind:ELEMENT_KIND_SECTION_FOOTER atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      CGFloat yPos = CGRectGetMaxY(spoonsFooterView.frame) + contentView.layoutMargins.top;
      [self.overlayView updateFrameWithSuperViewFrame:contentView.frame yPos:yPos arrowName:@"arrow.up" description:NSLocalizedString(@"onboarding.spoonBudget", nil) alignment:UIStackViewAlignmentCenter];
      break;
    }
    case DDHOnboardingStateSettings:
    {
      CGFloat yPos = contentView.layoutMargins.top;
      [self.overlayView updateFrameWithSuperViewFrame:contentView.frame yPos:yPos arrowName:@"arrow.up" description:NSLocalizedString(@"onboarding.settings", nil) alignment:UIStackViewAlignmentLeading];
      break;
    }
    case DDHOnboardingStateActions:
    {
      DDHActionsHeaderView *actionHeaderView = (DDHActionsHeaderView *)[[self contentView].collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
      CGFloat yPos = CGRectGetMaxY(actionHeaderView.frame) + contentView.layoutMargins.top;
      [self.overlayView updateFrameWithSuperViewFrame:contentView.frame yPos:yPos arrowName:@"arrow.up" description:NSLocalizedString(@"onboarding.actions", nil) alignment:UIStackViewAlignmentTrailing];
      break;
    }
    case DDHOnboardingStateReload:
    {
      CGFloat yPos = contentView.layoutMargins.top;
      [self.overlayView updateFrameWithSuperViewFrame:contentView.frame yPos:yPos arrowName:@"arrow.up" description:NSLocalizedString(@"onboarding.reload", nil) alignment:UIStackViewAlignmentTrailing];
      [self.overlayView.nextButton setTitle:NSLocalizedString(@"onboarding.done", nil) forState:UIControlStateNormal];
      break;
    }
    default:
      [NSUserDefaults.standardUserDefaults setOnboardingShown:YES];

      [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0;
      } completion:^(BOOL finished) {
        [self.overlayView removeFromSuperview];
        self.onboardingState = DDHOnboardingStateSpoonBudget;

        self.navigationController.navigationBar.userInteractionEnabled = YES;
        self.navigationController.navigationBar.accessibilityElementsHidden = NO;
        self.contentView.collectionView.userInteractionEnabled = YES;
        self.contentView.collectionView.accessibilityElementsHidden = NO;
      }];
      break;
  }

  [self setOnboardingState:[self onboardingState] + 1];
}

- (void)setupCollectionView:(UICollectionView *)collectionView {
  collectionView.delegate = self;

  [collectionView registerClass:[DDHSpoonsHeaderView class] forSupplementaryViewOfKind:ELEMENT_KIND_SECTION_HEADER withReuseIdentifier:[DDHSpoonsHeaderView identifier]];
  [collectionView registerClass:[DDHSpoonsFooterView class] forSupplementaryViewOfKind:ELEMENT_KIND_SECTION_FOOTER withReuseIdentifier:[DDHSpoonsFooterView identifier]];
  [collectionView registerClass:[DDHActionsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[DDHActionsHeaderView identifier]];

  DDHDay *day = self.dataStore.day;

  UICollectionViewCellRegistration *spoonCellRegistration = [DDHCellRegistrationProvider spoonCellRegistration:day];
  UICollectionViewCellRegistration *healthCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[DDHHealthDataCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
    DDHHealthDataCell *healthCell = (DDHHealthDataCell *)cell;
    [healthCell updateWithStepsYesterday:self.stepsYesterday today:self.stepsToday];
  }];
  UICollectionViewCellRegistration *actionCellRegistration = [DDHCellRegistrationProvider actionCellRegistration:self.dataStore];

  UICollectionViewDiffableDataSource *dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id _Nonnull itemIdentifier) {
    UICollectionViewCell *cell;
    NSNumber *sectionIdentifier = [self.dataSource sectionIdentifierForIndex:indexPath.section];
    switch ([sectionIdentifier integerValue]) {
      case DDHDayPlannerSectionSpoons:
        cell = [collectionView dequeueConfiguredReusableCellWithRegistration:spoonCellRegistration forIndexPath:indexPath item:itemIdentifier];
        break;
      case DDHDayPlannerSectionHealth:
        cell = [collectionView dequeueConfiguredReusableCellWithRegistration:healthCellRegistration forIndexPath:indexPath item:itemIdentifier];
        break;
      case DDHDayPlannerSectionActions:
        cell = [collectionView dequeueConfiguredReusableCellWithRegistration:actionCellRegistration forIndexPath:indexPath item:itemIdentifier];
        break;
    }
    return cell;
  }];
  self.dataSource = dataSource;

  [dataSource setSupplementaryViewProvider:^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {

    NSNumber *sectionIdentifier = [self.dataSource sectionIdentifierForIndex:indexPath.section];

    switch ([sectionIdentifier integerValue]) {
      case DDHDayPlannerSectionSpoons:
        if ([elementKind isEqualToString:ELEMENT_KIND_SECTION_HEADER]) {
          DDHSpoonsHeaderView *spoonsHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[DDHSpoonsHeaderView identifier] forIndexPath:indexPath];
          return spoonsHeaderView;
        } else {
          DDHSpoonsFooterView *spoonsFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[DDHSpoonsFooterView identifier] forIndexPath:indexPath];
          self.spoonsAmountLabel = spoonsFooterView.label;
          [self updateSpoonsAmount];
          return spoonsFooterView;
        }
        break;
      case DDHDayPlannerSectionActions: {
        DDHActionsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[DDHActionsHeaderView identifier] forIndexPath:indexPath];
        [headerView.addButton removeTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
      }
      default: {
        DDHActionsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[DDHActionsHeaderView identifier] forIndexPath:indexPath];
        [headerView.addButton removeTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
      }
        return nil;
        break;
    }
  }];

  dataSource.reorderingHandlers.canReorderItemHandler = ^BOOL(id _Nonnull itemIdentifier) {
    return (NO == [day.spoonsIdentifiers containsObject:itemIdentifier]);
  };

  dataSource.reorderingHandlers.didReorderHandler = ^(NSDiffableDataSourceTransaction<NSNumber *, NSUUID *> * _Nonnull transaction) {
    NSInteger numberOfSpoons = [day.spoonsIdentifiers count];
    NSInteger finalIndex = transaction.difference.insertions.firstObject.index - numberOfSpoons;
    NSInteger initialIndex = transaction.difference.insertions.firstObject.associatedIndex - numberOfSpoons;
    [day movePlannedActionFromIndex:initialIndex toFinalIndex:finalIndex];
    [self.dataStore saveData];
  };
}

- (void)updateWithDay:(DDHDay *)day {
  NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
  [snapshot appendSectionsWithIdentifiers:@[@(DDHDayPlannerSectionSpoons)]];
  if ([NSUserDefaults.standardUserDefaults showSteps]) {
    [snapshot appendSectionsWithIdentifiers:@[@(DDHDayPlannerSectionHealth)]];
    [snapshot appendItemsWithIdentifiers:@[[NSUUID UUID]] intoSectionWithIdentifier:@(DDHDayPlannerSectionHealth)];
  }
  [snapshot appendSectionsWithIdentifiers:@[[NSNumber numberWithInteger:DDHDayPlannerSectionActions]]];
  [snapshot appendItemsWithIdentifiers:day.spoonsIdentifiers intoSectionWithIdentifier:@(DDHDayPlannerSectionSpoons)];
  [snapshot appendItemsWithIdentifiers:day.idsOfPlannedActions intoSectionWithIdentifier:@(DDHDayPlannerSectionActions)];
  [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
  [self updateSpoonsAmount];
}

- (void)reload {
  NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
  [snapshot reconfigureItemsWithIdentifiers:snapshot.itemIdentifiers];
  [self.dataSource applySnapshot:snapshot animatingDifferences:YES];

  [WidgetContentLoader reloadWidgetContent];
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *sectionIdentifier = [self.dataSource sectionIdentifierForIndex:indexPath.section];
  if ([sectionIdentifier integerValue] == DDHDayPlannerSectionActions) {
    NSUUID *actionId = [self.dataSource itemIdentifierForIndexPath:indexPath];
    DDHAction *action = [self.dataStore actionForId:actionId];
    DDHDay *day = self.dataStore.day;
    DDHActionState actionState = [day actionStateForAction:action];
    if (actionState == DDHActionStateCompleted) {
      [day uncompleteAction:action];
    } else {
      [day completeAction:action];
    }
    UISelectionFeedbackGenerator *feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
    [feedbackGenerator prepare];
    [feedbackGenerator selectionChanged];
    [self.dataStore saveData];

    [self updateWithDay:self.dataStore.day];

    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    [snapshot reconfigureItemsWithIdentifiers:snapshot.itemIdentifiers];
    [self.dataSource applySnapshot:snapshot animatingDifferences:NO];

    [self updateSpoonsAmount];

    [WidgetContentLoader reloadWidgetContent];
  }
}

- (void)updateSpoonsAmount {
  DDHDay *day = self.dataStore.day;
  NSString *footerString;
  if (day.carryOverSpoons > 0) {
    footerString = [NSString stringWithFormat:NSLocalizedString(@"dayPlanner.spoonAmounts.withCarryOver", nil), day.plannedSpoons, day.carryOverSpoons, day.amountOfSpoons, day.completedSpoons, day.carryOverSpoons, day.amountOfSpoons];
  } else {
    footerString = [NSString stringWithFormat:NSLocalizedString(@"dayPlanner.spoonAmounts.withoutCarryOver", nil), day.plannedSpoons, day.amountOfSpoons, day.completedSpoons, day.amountOfSpoons];
  }
  BOOL spoonDeficit = (day.plannedSpoons - day.carryOverSpoons) > day.amountOfSpoons;
  if (spoonDeficit) {
    self.spoonsAmountLabel.textColor = UIColor.systemRedColor;
  } else {
    self.spoonsAmountLabel.textColor = UIColor.labelColor;
  }
  self.spoonsAmountLabel.text = footerString;
}

// MARK: - Actions
- (void)add:(UIButton *)sender {
  [self.delegate didSelectAddButtonInViewController:self];
}

- (void)reset:(UIBarButtonItem *)sender {
  DDHDay *day = self.dataStore.day;
  [day resetWithDailySpoons:[NSUserDefaults.standardUserDefaults dailySpoons]];

  [self.dataStore saveData];

  [self updateWithDay:day];

  NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
  [snapshot reconfigureItemsWithIdentifiers:snapshot.itemIdentifiers];
  [self.dataSource applySnapshot:snapshot animatingDifferences:YES];

  [self updateSpoonsAmount];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {

  UICollectionView *collectionView = [self.contentView collectionView];

  switch (sender.state) {
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

- (void)didSelectSettings:(UIBarButtonItem *)sender {
  [self.delegate didSelectSettingsButtonInViewController:self];
}

- (UIContextualAction *)contextualUnplanActionWithAction:(DDHAction *)action {
  return [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"dayPlanner.unplan", nil) handler:^(UIContextualAction * _Nonnull contextualAction, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

    DDHDay *day = self.dataStore.day;
    [day unplanAction:action];
    [self.dataStore saveData];
    [self updateWithDay:day];

    [WidgetContentLoader reloadWidgetContent];
  }];
}

- (UIContextualAction *)contextualEditActionWithAction:(DDHAction *)action {
  return [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"dayPlanner.edit", nil) handler:^(UIContextualAction * _Nonnull contextualAction, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

    [self.delegate editActionFromViewController:self action:action];
    completionHandler(true);
  }];
}

// MARK: - HealthKit
- (void)fetchStepsIfNeeded {
  if ([HKHealthStore isHealthDataAvailable] && [NSUserDefaults.standardUserDefaults showSteps]) {
    _healthStore = [[HKHealthStore alloc] init];

    HKQuantityType *stepType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSet<HKObjectType *> *types = [[NSSet alloc] initWithObjects:stepType, nil];

    [_healthStore requestAuthorizationToShareTypes:nil readTypes:types completion:^(BOOL success, NSError * _Nullable error) {
      if (success) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *startOfToday = [calendar startOfDayForDate:[NSDate date]];
        NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:startOfToday options:0];
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startOfToday options:0];

        NSPredicate *todayPredicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:0];
        NSDateComponents *day = [[NSDateComponents alloc] init];
        day.day = 1;

        HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:stepType quantitySamplePredicate:todayPredicate options:HKStatisticsOptionCumulativeSum anchorDate:startDate intervalComponents:day];

        query.initialResultsHandler = ^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
          NSLog(@"result: %@", result);
          self.stepsYesterday = [[result.statistics.firstObject sumQuantity] doubleValueForUnit:[HKUnit countUnit]];
          self.stepsToday = [[result.statistics.lastObject sumQuantity] doubleValueForUnit:[HKUnit countUnit]];
          dispatch_async(dispatch_get_main_queue(), ^{
            [self reload];
          });
        };

//        HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:todayPredicate limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
//          if (nil == error && nil != results) {
//            NSLog(@"results: %@", results);
//            self.steps = ((HKQuantitySample *)results.firstObject).count;
//            dispatch_async(dispatch_get_main_queue(), ^{
//              [self reload];
//            });
//          } else {
//            NSLog(@"error: %@", error);
//          }
//        }];

        [self.healthStore executeQuery:query];
      }
    }];
  }
}

@end
