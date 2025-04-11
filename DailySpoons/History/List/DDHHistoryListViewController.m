//  Created by Dominik Hauser on 16.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryListViewController.h"
#import "DDHHistoryListView.h"
#import "DDHHistoryEntryCell.h"
#import "DDHHistoryEmptyCell.h"
#import "DDHHistoryEntry.h"
#import "DDHDataStore.h"
#import "DDHHistoryListDiffableDataSource.h"
#import <HealthKit/HealthKit.h>
#import "NSFileManager+Extension.h"

@interface DDHHistoryListViewController ()
@property (nonatomic, strong) DDHHistoryListDiffableDataSource *dataSource;
@property (nonatomic, strong) NSArray<DDHHistoryEntry *> *historyEntries;
@property (nonatomic, strong) NSDateFormatter *dayDateFormatter;
@property (nonatomic, strong) NSDateFormatter *monthYearDateFormatter;
@property (nonatomic, weak, readonly) DDHHistoryListView *contentView;
@property (nonatomic, strong) DDHDataStore *dataStore;
@property (nonatomic, strong) HKHealthStore *healthStore;
@property (nonatomic, strong) NSUUID *emptyStateUUID;
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

  UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)];
  self.navigationItem.rightBarButtonItem = closeButton;

  UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(export:)];
  self.navigationItem.leftBarButtonItem = exportButton;

  UITableView *tableView = self.contentView.tableView;

  tableView.delegate = self;

  [tableView registerClass:[DDHHistoryEmptyCell class] forCellReuseIdentifier:[DDHHistoryEmptyCell identifier]];
  [tableView registerClass:[DDHHistoryEntryCell class] forCellReuseIdentifier:[DDHHistoryEntryCell identifier]];

  _dataSource = [[DDHHistoryListDiffableDataSource alloc] initWithTableView:tableView cellProvider:^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSUUID * _Nonnull itemIdentifier) {
    UITableViewCell *cell;
    if (nil != self.emptyStateUUID) {
      DDHHistoryEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:[DDHHistoryEmptyCell identifier] forIndexPath:indexPath];
      cell = emptyCell;
    } else {
      DDHHistoryEntryCell *entryCell = [tableView dequeueReusableCellWithIdentifier:[DDHHistoryEntryCell identifier] forIndexPath:indexPath];
      NSUInteger index = [self.historyEntries indexOfObjectPassingTest:^BOOL(DDHHistoryEntry * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.uuid isEqual:itemIdentifier];
      }];
      if (index != NSNotFound) {
        DDHHistoryEntry *entry = self.historyEntries[index];
        [entryCell updateWithHistoryEntry:entry dateFormatter:self.dayDateFormatter];
        if (@available(iOS 18.0, *)) {
          HKStateOfMind *stateOfMind = [self stateOfMindForDate:entry.date];
          if (nil != stateOfMind) {
            NSString *classificationString = [self classificationStringFromStateOfMind:stateOfMind];
            [entryCell updateMood:classificationString valence:stateOfMind.valence];
          }
#if TARGET_IPHONE_SIMULATOR
          int valenceInt = rand() % 200;
          double valence = (double)valenceInt/100.0 - 1.0;
          if (rand() % 100 < 60) {
            [entryCell updateMood:@"" valence:valence];
          }
#endif
        }
      }
      cell = entryCell;
    }
    return cell;
  }];

  NSArray<DDHHistoryEntry *> *historyEntries = [self.dataStore history];
#if TARGET_IPHONE_SIMULATOR
  historyEntries = @[
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-24 * 60 * 60] amountOfSpoons:12 plannedSpoons:11 completedSpoons:10 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-2 * 24 * 60 * 60] amountOfSpoons:12 plannedSpoons:11 completedSpoons:11 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-3 * 24 * 60 * 60] amountOfSpoons:12 plannedSpoons:12 completedSpoons:11 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-4 * 24 * 60 * 60] amountOfSpoons:13 plannedSpoons:12 completedSpoons:12 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-5 * 24 * 60 * 60] amountOfSpoons:13 plannedSpoons:12 completedSpoons:12 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-6 * 24 * 60 * 60] amountOfSpoons:12 plannedSpoons:12 completedSpoons:11 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-7 * 24 * 60 * 60] amountOfSpoons:12 plannedSpoons:12 completedSpoons:12 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-8 * 24 * 60 * 60] amountOfSpoons:12 plannedSpoons:12 completedSpoons:11 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-9 * 24 * 60 * 60] amountOfSpoons:12 plannedSpoons:12 completedSpoons:11 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-10 * 24 * 60 * 60] amountOfSpoons:11 plannedSpoons:11 completedSpoons:11 completedActionsString:@""],
    [[DDHHistoryEntry alloc] initUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-11 * 24 * 60 * 60] amountOfSpoons:12 plannedSpoons:12 completedSpoons:11 completedActionsString:@""],
  ];
#endif
  if ([historyEntries count] < 1) {
    _emptyStateUUID = [NSUUID UUID];
  }
  [self updateWithHistoryEntries:historyEntries];

#if TARGET_IPHONE_SIMULATOR
#else
  [self fetchStateOfMindIfNeeded];
#endif
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
    if (NO == [monthString isEqualToString:currentSectionIdentifier] &&
        NO == [snapshot.sectionIdentifiers containsObject:currentSectionIdentifier]) {
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

  if ([snapshot.sectionIdentifiers count] < 1 && nil != self.emptyStateUUID) {
    [snapshot appendSectionsWithIdentifiers:@[@"---"]];
    [snapshot appendItemsWithIdentifiers:@[self.emptyStateUUID]];
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

// MARK: - Actions
- (void)close:(UIBarButtonItem *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)export:(UIBarButtonItem *)sender {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.timeStyle = NSDateFormatterNoStyle;
  dateFormatter.dateStyle = NSDateFormatterMediumStyle;

  NSMutableArray<NSString *> *outputArray = [[NSMutableArray alloc] initWithCapacity:[self.historyEntries count] + 1];
  [outputArray addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@", NSLocalizedString(@"history.date", nil), NSLocalizedString(@"history.spoons", nil), NSLocalizedString(@"history.planned", nil), NSLocalizedString(@"history.completed", nil), NSLocalizedString(@"history.stateOfMind", nil)]];
  for (DDHHistoryEntry *entry in self.historyEntries) {
    double valence = 0;
    if (@available(iOS 18.0, *)) {
      HKStateOfMind *stateOfMind = [self stateOfMindForDate:entry.date];
      if (nil != stateOfMind) {
        valence = stateOfMind.valence;
      }
    }
    NSString *line = [NSString stringWithFormat:@"%@,%ld,%ld,%ld,%lf", [dateFormatter stringFromDate:entry.date], entry.amountOfSpoons, entry.plannedSpoons, entry.completedSpoons, valence];
    [outputArray addObject:line];
  }
  NSString *output = [outputArray componentsJoinedByString:@"\n"];
  NSLog(@"output: %@", output);
  NSData *outputData = [output dataUsingEncoding:NSUTF8StringEncoding];
  NSURL *fileURL = [[NSFileManager defaultManager] csvExportURLForDate:[NSDate date]];
  [outputData writeToURL:fileURL atomically:YES];

  UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
  [self presentViewController:activityViewController animated:YES completion:nil];
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

- (NSString *)classificationStringFromStateOfMind:(HKStateOfMind *)stateOfMind API_AVAILABLE(ios(18.0)) {
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
