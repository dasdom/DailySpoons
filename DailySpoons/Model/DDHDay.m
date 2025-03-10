//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHDay.h"
#import "DDHAction.h"
#import "NSUserDefaults+Helper.h"

NSString * const dateKey = @"dateKey";
NSString * const amountOfSpoonsKey = @"amountOfSpoonsKey";
NSString * const carryOverSpoonsKey = @"carryOverSpoonsKey";
NSString * const completedActionsKey = @"completedActionsKey";
NSString * const plannedActionsKey = @"plannedActionsKey";

@interface DDHDay ()
@property (nonatomic, strong) NSArray<DDHAction *> *completedActions;
@property (nonatomic, strong) NSArray<DDHAction *> *plannedActions;
@end

@implementation DDHDay
- (instancetype)init {
  if (self = [super init]) {
    _date = [NSDate now];
    [self setAmountOfSpoons:[[NSUserDefaults standardUserDefaults] dailySpoons]];
    _carryOverSpoons = 0;

    _completedActions = [[NSArray alloc] init];
    _plannedActions = [[NSArray alloc] init];
  }
  return self;
}

- (instancetype)initAmountOfSpoons:(NSInteger)amountOfSpoons plannedActions:(NSArray<DDHAction *> *)plannedActions completedActions:(NSArray<DDHAction *> *)completedActions {
  if (self = [super init]) {
    _date = [NSDate now];
    _carryOverSpoons = 0;

    [self setAmountOfSpoons:amountOfSpoons];

    _plannedActions = plannedActions;
    _completedActions = completedActions;
  }
  return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    NSTimeInterval timeInterval = [[dictionary valueForKey:dateKey] doubleValue];
    _date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    _carryOverSpoons = [[dictionary valueForKey:carryOverSpoonsKey] integerValue];

    NSArray *rawComletedActions = [dictionary valueForKey:completedActionsKey];
    NSMutableArray *completedActions = [[NSMutableArray alloc] init];
    [rawComletedActions enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
      DDHAction *action = [[DDHAction alloc] initWithDictionary:dictionary];
      [completedActions addObject:action];
    }];
    _completedActions = [completedActions copy];

    NSArray *rawPlannedActions = [dictionary valueForKey:plannedActionsKey];
    NSMutableArray *plannedActions = [[NSMutableArray alloc] init];
    [rawPlannedActions enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
      DDHAction *action = [[DDHAction alloc] initWithDictionary:dictionary];
      [plannedActions addObject:action];
    }];
    _plannedActions = [plannedActions copy];

    NSInteger amountOfSpoons = [[dictionary valueForKey:amountOfSpoonsKey] integerValue];
    [self setAmountOfSpoons:amountOfSpoons];
  }
  return self;
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  NSTimeInterval timeInterval = [[self date] timeIntervalSince1970];
  [dictionary setObject:[NSNumber numberWithDouble:timeInterval] forKey:dateKey];

  [dictionary setObject:[NSNumber numberWithInteger:[self unmodifiedAmountOfSpoons]] forKey:amountOfSpoonsKey];
  [dictionary setObject:[NSNumber numberWithInteger:[self carryOverSpoons]] forKey:carryOverSpoonsKey];

  NSMutableArray *completedActions = [[NSMutableArray alloc] init];
  [[self completedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [completedActions addObject:[action dictionary]];
  }];
  [dictionary setObject:[completedActions copy] forKey:completedActionsKey];

  NSMutableArray *plannedActions = [[NSMutableArray alloc] init];
  [[self plannedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [plannedActions addObject:[action dictionary]];
  }];
  [dictionary setObject:[plannedActions copy] forKey:plannedActionsKey];

  return [dictionary copy];
}

- (void)setAmountOfSpoons:(NSInteger)amountOfSpoons {
  NSMutableArray<NSUUID *> *spoonsIdentifiers = [[NSMutableArray alloc] initWithCapacity:amountOfSpoons];
  for (NSInteger i = 0; i < amountOfSpoons - [self carryOverSpoons]; i++) {
    [spoonsIdentifiers addObject:[NSUUID UUID]];
  }
  for (NSInteger i = 0; i < [self plannedSpoonSources]; i++) {
    [spoonsIdentifiers addObject:[NSUUID UUID]];
  }
  [self setSpoonsIdentifiers:spoonsIdentifiers];
  _unmodifiedAmountOfSpoons = amountOfSpoons;
}

- (NSInteger)amountOfSpoons {
  __block NSInteger amountOfSpoons = _unmodifiedAmountOfSpoons;
  [[self plannedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj spoons] < 0) {
      NSInteger negativeSpoons = -[obj spoons];
      amountOfSpoons += negativeSpoons;
    }
  }];

  return amountOfSpoons;
}

- (NSInteger)completedSpoons {
  __block NSInteger completedSpoons = 0;
  [[self completedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([action spoons] > 0) {
      completedSpoons += [action spoons];
    }
  }];
  return completedSpoons;
}

- (NSInteger)plannedSpoons {
  __block NSInteger plannedSpoons = 0;
  [[self plannedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([action spoons] > 0) {
      plannedSpoons += [action spoons];
    }
  }];
  return plannedSpoons;
}

- (NSInteger)completedSpoonSources {
  __block NSInteger completedSpoons = 0;
  [[self completedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([action spoons] < 0) {
      completedSpoons += -[action spoons];
    }
  }];
  return completedSpoons;
}

- (NSInteger)plannedSpoonSources {
  __block NSInteger plannedSpoons = 0;
  [[self plannedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([action spoons] < 0) {
      plannedSpoons += -[action spoons];
    }
  }];
  return plannedSpoons;
}

- (void)updateAction:(DDHAction *)action {
  [[self plannedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([[obj actionId] isEqual:[action actionId]]) {
      [obj setName:[action name]];
      [obj setSpoons:[action spoons]];
      *stop = YES;
    }
  }];
  [[self completedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([[obj actionId] isEqual:[action actionId]]) {
      [obj setName:[action name]];
      [obj setSpoons:[action spoons]];
      *stop = YES;
    }
  }];
}

- (NSInteger)availableSpoons {
  return [self amountOfSpoons] - [self completedSpoons];
}

- (void)planAction:(DDHAction *)action {
  [self setPlannedActions:[[self plannedActions] arrayByAddingObject:action]];
  [self setAmountOfSpoons:[self unmodifiedAmountOfSpoons]];
}

- (void)unplanAction:(DDHAction *)action {
  NSMutableArray<DDHAction *> *plannedActions = [[self plannedActions] mutableCopy];
  [plannedActions removeObject:action];
  [self setPlannedActions:[plannedActions copy]];
  [self setAmountOfSpoons:[self unmodifiedAmountOfSpoons]];
}

- (void)movePlannedActionFromIndex:(NSInteger)initialIndex toFinalIndex:(NSInteger)finalIndex {
  NSMutableArray<DDHAction *> *plannedActions = [[self plannedActions] mutableCopy];
  DDHAction *action = [plannedActions objectAtIndex:initialIndex];
  [plannedActions removeObjectAtIndex:initialIndex];
  [plannedActions insertObject:action atIndex:finalIndex];
  [self setPlannedActions:[plannedActions copy]];
}

- (void)completeAction:(DDHAction *)action {
  [self setCompletedActions:[[self completedActions] arrayByAddingObject:action]];
}

- (void)uncompleteAction:(DDHAction *)action {
  NSMutableArray<DDHAction *> *completedActions = [[self completedActions] mutableCopy];
  [completedActions removeObject:action];
  [self setCompletedActions:[completedActions copy]];
}

- (NSArray<NSUUID *> *)idsOfCompletedActions {
  NSMutableArray<NSUUID *> *ids = [[NSMutableArray alloc] initWithCapacity:[self.completedActions count]];
  [self.completedActions enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [ids addObject:action.actionId];
  }];
  return [ids copy];
}

- (NSArray<NSUUID *> *)idsOfPlannedActions {
  NSMutableArray<NSUUID *> *ids = [[NSMutableArray alloc] initWithCapacity:[self.plannedActions count]];
//  NSArray<DDHAction *> *sortedPlannedActions = [self.plannedActions sortedArrayUsingComparator:^NSComparisonResult(DDHAction * _Nonnull obj1, DDHAction * _Nonnull obj2) {
//    if ([self.completedActions containsObject:obj1]) {
//      if ([self.completedActions containsObject:obj2]) {
//        return [obj1.name compare:obj2.name];
//      } else {
//        return NSOrderedDescending;
//      }
//    } else if ([self.completedActions containsObject:obj2]) {
//      return NSOrderedAscending;
//    } else {
//      return [obj1.name compare:obj2.name];
//    }
//  }];
  [self.plannedActions enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [ids addObject:action.actionId];
  }];
  return [ids copy];
}

- (DDHActionState)actionStateForAction:(DDHAction *)action {
  if ([[self completedActions] containsObject:action]) {
    return DDHActionStateCompleted;
  } else if ([[self plannedActions] containsObject:action]) {
    return DDHActionStatePlanned;
  } else {
    return DDHActionStateNone;
  }
}

- (void)resetWithDailySpoons:(NSInteger)dailySpoons {
  NSInteger carryOverSpoons = [self completedSpoons] - ([self amountOfSpoons] - [self carryOverSpoons]);
  [self setCarryOverSpoons:MAX(0, carryOverSpoons)];
  [self setDate:[NSDate now]];
  [self setCompletedActions:[[NSArray alloc] init]];
  [self setAmountOfSpoons:dailySpoons];
}
@end
