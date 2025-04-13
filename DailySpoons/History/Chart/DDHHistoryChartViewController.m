//  Created by Dominik Hauser on 11.04.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryChartViewController.h"
#import "DDHHistoryChartView.h"
#import "DDHHistoryEntry.h"

@interface DDHHistoryChartViewController ()
@property (nonatomic, strong) NSArray<DDHHistoryEntry *> *historyEntries;
@end

@implementation DDHHistoryChartViewController

- (instancetype)initWithHistoryEntries:(NSArray<DDHHistoryEntry *> *)historyEntires {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _historyEntries = historyEntires;
  }
  return self;
}

- (void)loadView {
  NSInteger maxValue = 0;
  for (DDHHistoryEntry *entry in self.historyEntries) {
    maxValue = MAX(maxValue, entry.completedSpoons);
    maxValue = MAX(maxValue, entry.plannedSpoons);
    maxValue = MAX(maxValue, entry.amountOfSpoons);
  }
  self.view = [[DDHHistoryChartView alloc] initWithHistoryEntries:self.historyEntries maxValue:maxValue];
}

@end
