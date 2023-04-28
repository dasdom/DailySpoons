//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHDay.h"
#import "DDHAction.h"

@interface DDHDay ()
@property (nonatomic, strong) NSArray<DDHAction *> *completedActions;
@property (nonatomic, strong) NSArray<DDHAction *> *plannedActions;
@end

@implementation DDHDay
- (instancetype)init {
  if (self = [super init]) {
    _date = [NSDate now];
    _amountOfSpoons = 12;
    _carryOverSpoons = 0;

    _completedActions = [[NSArray alloc] init];
    _plannedActions = [[NSArray alloc] init];
  }
  return self;
}

- (NSInteger)completedSpoons {
  __block NSInteger completedSpoons;
  [[self completedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    completedSpoons += [action spoons];
  }];
  return completedSpoons;
}

- (NSInteger)plannedSpoons {
  __block NSInteger plannedSpoons;
  [[self completedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    plannedSpoons += [action spoons];
  }];
  return plannedSpoons;
}

- (NSInteger)availableSpoons {
  return [self plannedSpoons] - [self completedSpoons];
}
@end
