//  Created by Dominik Hauser on 16.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryListViewController.h"
#import "DDHHistoryListView.h"
#import "DDHHistoryEntryCell.h"
#import "DDHHistoryEntry.h"
#import "DDHDataStore.h"
#import "DDHHistoryListDiffableDataSource.h"
#import <HealthKit/HealthKit.h>

@interface DDHHistoryListViewController ()
@property (nonatomic, strong) DDHHistoryListDiffableDataSource *dataSource;
@property (nonatomic, strong) NSArray<DDHHistoryEntry *> *historyEntries;
@property (nonatomic, strong) NSDateFormatter *dayDateFormatter;
@property (nonatomic, strong) NSDateFormatter *monthYearDateFormatter;
@property (nonatomic, weak, readonly) DDHHistoryListView *contentView;
@property (nonatomic, strong) DDHDataStore *dataStore;
@property (nonatomic, strong) HKHealthStore *healthStore;
@end

API_AVAILABLE(ios(18.0))
@interface DDHHistoryListViewController () <UITableViewDelegate>
@property (nonatomic, strong) NSArray<HKStateOfMind *> *stateOfMindEntries;
@end

@implementation DDHHistoryListViewController

- (instancetype)init {
  if (self = [super init]) {
    _dayDateFormatter = [[NSDateFormatter alloc] init];
    _dayDateFormatter.dateFormat = @"dd";

    _monthYearDateFormatter = [[NSDateFormatter alloc] init];
    _monthYearDateFormatter.dateFormat = @"MMM yyyy";

    _dataStore = [[DDHDataStore alloc] init];
  }
  return self;
}

- (void)loadView {
  self.view = [[DDHHistoryListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (DDHHistoryListView *)contentView {
  return (DDHHistoryListView *)self.view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"history.title", nil);

  UITableView *tableView = self.contentView.tableView;

  tableView.delegate = self;

  [tableView registerClass:[DDHHistoryEntryCell class] forCellReuseIdentifier:[DDHHistoryEntryCell identifier]];

  _dataSource = [[DDHHistoryListDiffableDataSource alloc] initWithTableView:tableView cellProvider:^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSUUID * _Nonnull itemIdentifier) {
    DDHHistoryEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:[DDHHistoryEntryCell identifier] forIndexPath:indexPath];
    NSUInteger index = [self.historyEntries indexOfObjectPassingTest:^BOOL(DDHHistoryEntry * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      return [obj.uuid isEqual:itemIdentifier];
    }];
    if (index != NSNotFound) {
      DDHHistoryEntry *entry = self.historyEntries[index];
      [cell updateWithHistoryEntry:entry dateFormatter:self.dayDateFormatter];
      if (@available(iOS 18.0, *)) {
        HKStateOfMind *stateOfMind = [self stateOfMindForDate:entry.date];
        if (nil != stateOfMind) {
          NSString *classificationString = [self classificationStringFromStateOfMind:stateOfMind];
          [cell updateMood:classificationString valence:stateOfMind.valence];
        }
      }
    }
    return cell;
  }];

  NSArray<DDHHistoryEntry *> *historyEntries = [self.dataStore history];
  [self updateWithHistoryEntries:historyEntries];

  [self fetchStateOfMindIfNeeded];
}

- (void)updateWithHistoryEntries:(NSArray<DDHHistoryEntry *> *)historyEntries {
  self.historyEntries = historyEntries;
  NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];

  NSString *currentSectionIdentifier;
  NSMutableArray<NSUUID *> *itemIds = [[NSMutableArray alloc] init];
  for (DDHHistoryEntry *entry in historyEntries) {
    NSString *monthString = [self.monthYearDateFormatter stringFromDate:entry.date];
    if (nil == currentSectionIdentifier) {
      currentSectionIdentifier = monthString;
    }
    if (monthString != currentSectionIdentifier) {
      [snapshot appendSectionsWithIdentifiers:@[currentSectionIdentifier]];
      [snapshot appendItemsWithIdentifiers:itemIds intoSectionWithIdentifier:currentSectionIdentifier];

      currentSectionIdentifier = monthString;
      [itemIds removeAllObjects];
    }
    [itemIds addObject:entry.uuid];
  }

  if ([itemIds count] > 0 &&
      NO == [currentSectionIdentifier isEqualToString:@""]) {
    [snapshot appendSectionsWithIdentifiers:@[currentSectionIdentifier]];
    [snapshot appendItemsWithIdentifiers:itemIds intoSectionWithIdentifier:currentSectionIdentifier];
  }

  [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSUUID *itemIdentifier = [self.dataSource itemIdentifierForIndexPath:indexPath];
  NSUInteger index = [self.historyEntries indexOfObjectPassingTest:^BOOL(DDHHistoryEntry * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    return [obj.uuid isEqual:itemIdentifier];
  }];
  if (index != NSNotFound) {
    DDHHistoryEntry *entry = self.historyEntries[index];
  }
}

// MARK: - HealthKit

- (void)fetchStateOfMindIfNeeded {
  if (@available(iOS 18.0, *)) {
    _healthStore = [[HKHealthStore alloc] init];

    HKStateOfMindType *stateOfMindType = [HKSampleType stateOfMindType];
    NSSet<HKObjectType *> *types = [[NSSet alloc] initWithObjects:stateOfMindType, nil];

    [_healthStore requestAuthorizationToShareTypes:nil readTypes:types completion:^(BOOL success, NSError * _Nullable error) {

      NSCalendar *calendar = [NSCalendar currentCalendar];
      NSDate *startOfToday = [calendar startOfDayForDate:[NSDate date]];
      NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-100 toDate:startOfToday options:0];
      NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startOfToday options:0];
      NSPredicate *todayPredicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:0];

      HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stateOfMindType predicate:todayPredicate limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {

        if (nil == error && nil != results) {
          NSLog(@"results: %@", results);
          dispatch_async(dispatch_get_main_queue(), ^{
            self.stateOfMindEntries = results;

            NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
            [self.dataSource applySnapshotUsingReloadData:snapshot];
          });
        } else {
          NSLog(@"error: %@", error);
        }
      }];

      [self.healthStore executeQuery:query];
    }];
  } else {
    // do nothing
  }
}

- (HKStateOfMind *)stateOfMindForDate:(NSDate *)date API_AVAILABLE(ios(18.0)) {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  HKStateOfMind *stateOfMindToReturn;
  for (HKStateOfMind *stateOfMind in self.stateOfMindEntries) {
    if (stateOfMind.kind == HKStateOfMindKindDailyMood &&
        [calendar isDate:stateOfMind.endDate inSameDayAsDate:date]) {
      stateOfMindToReturn = stateOfMind;
      break;
    }
  }
  return stateOfMindToReturn;
}

- (NSString *)classificationStringFromStateOfMind:(HKStateOfMind *)stateOfMind  API_AVAILABLE(ios(18.0)) {
  NSString *classificationString;
  switch (stateOfMind.valenceClassification) {
    case HKStateOfMindValenceClassificationVeryUnpleasant:
      classificationString = NSLocalizedString(@"history.classification.veryUnpleasant", nil);
      break;
    case HKStateOfMindValenceClassificationUnpleasant:
      classificationString = NSLocalizedString(@"history.classification.unpleasant", nil);
      break;
    case HKStateOfMindValenceClassificationSlightlyUnpleasant:
      classificationString = NSLocalizedString(@"history.classification.slightlyUnpleasant", nil);
      break;
    case HKStateOfMindValenceClassificationNeutral:
      classificationString = NSLocalizedString(@"history.classification.neutral", nil);
      break;
    case HKStateOfMindValenceClassificationSlightlyPleasant:
      classificationString = NSLocalizedString(@"history.classification.slightlyPleasant", nil);
      break;
    case HKStateOfMindValenceClassificationPleasant:
      classificationString = NSLocalizedString(@"history.classification.pleasant", nil);
      break;
    case HKStateOfMindValenceClassificationVeryPleasant:
      classificationString = NSLocalizedString(@"history.classification.veryPleasant", nil);
      break;
  }
  return classificationString;
}

@end
