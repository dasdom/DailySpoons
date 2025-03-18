//  Created by Dominik Hauser on 14.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryEntry.h"

@implementation DDHHistoryEntry
- (instancetype)initUUID:(NSUUID *)uuid date:(NSDate *)date amountOfSpoons:(NSInteger)amountOfSpoons plannedSpoons:(NSInteger)plannedSpoons completedSpoons:(NSInteger)completedSpoons completedActionsString:(NSString *)completedActionsString {
  if (self = [super init]) {
    self.uuid = uuid;
    self.date = date;
    self.amountOfSpoons = amountOfSpoons;
    self.plannedSpoons = plannedSpoons;
    self.completedSpoons = completedSpoons;
    self.completedActionsString = completedActionsString;
  }
  return self;
}
@end
