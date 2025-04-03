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
//@property (nonatomic, strong) NSArray<DDHAction *> *completedActions;
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
    NSTimeInterval timeInterval = [dictionary[dateKey] doubleValue];
    _date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    _carryOverSpoons = [dictionary[carryOverSpoonsKey] integerValue];

    NSArray *rawCompletedActions = dictionary[completedActionsKey];
    NSMutableArray *completedActions = [[NSMutableArray alloc] init];
    [rawCompletedActions enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
      DDHAction *action = [[DDHAction alloc] initWithDictionary:dictionary];
      [completedActions addObject:action];
    }];
    _completedActions = [completedActions copy];

    NSArray *rawPlannedActions = dictionary[plannedActionsKey];
    NSMutableArray *plannedActions = [[NSMutableArray alloc] init];
    [rawPlannedActions enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
      DDHAction *action = [[DDHAction alloc] initWithDictionary:dictionary];
      [plannedActions addObject:action];
    }];
    _plannedActions = [plannedActions copy];

    NSInteger amountOfSpoons = [dictionary[amountOfSpoonsKey] integerValue];
    [self setAmountOfSpoons:amountOfSpoons];
  }
  return self;
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  NSTimeInterval timeInterval = [[self date] timeIntervalSince1970];
  dictionary[dateKey] = @(timeInterval);

  dictionary[amountOfSpoonsKey] = @(self.unmodifiedAmountOfSpoons);
  dictionary[carryOverSpoonsKey] = @(self.carryOverSpoons);

  NSMutableArray *completedActions = [[NSMutableArray alloc] init];
  [[self completedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [completedActions addObject:[action dictionary]];
  }];
  dictionary[completedActionsKey] = [completedActions copy];

  NSMutableArray *plannedActions = [[NSMutableArray alloc] init];
  [[self plannedActions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [plannedActions addObject:[action dictionary]];
  }];
  dictionary[plannedActionsKey] = [plannedActions copy];

  return [dictionary copy];
}

- (void)setAmountOfSpoons:(NSInteger)amountOfSpoons {
  NSMutableArray<NSUUID *> *spoonsIdentifiers = [[NSMutableArray alloc] initWithCapacity:amountOfSpoons];
  for (NSInteger i = 0; i < amountOfSpoons - self.carryOverSpoons; i++) {
    [spoonsIdentifiers addObject:[NSUUID UUID]];
  }
  for (NSInteger i = 0; i < [self plannedSpoonSources]; i++) {
    [spoonsIdentifiers addObject:[NSUUID UUID]];
  }
  self.spoonsIdentifiers = spoonsIdentifiers;
  _unmodifiedAmountOfSpoons = amountOfSpoons;
}

- (NSInteger)amountOfSpoons {
  NSInteger amountOfSpoons = _unmodifiedAmountOfSpoons;
  for (DDHAction *action in self.plannedActions) {
    if (action.spoons < 0) {
      NSInteger negativeSpoons = -action.spoons;
      amountOfSpoons += negativeSpoons;
    }
  }

  return amountOfSpoons;
}

- (NSInteger)completedSpoons {
  NSInteger completedSpoons = 0;
  for (DDHAction *action in self.completedActions) {
    if (action.spoons > 0) {
      completedSpoons += action.spoons;
    }
  }
  return completedSpoons;
}

- (NSInteger)plannedSpoons {
  NSInteger plannedSpoons = 0;
  for (DDHAction *action in self.plannedActions) {
    if (action.spoons > 0) {
      plannedSpoons += action.spoons;
    }
  }
  return plannedSpoons;
}

- (NSInteger)completedSpoonSources {
  NSInteger completedSpoons = 0;
  for (DDHAction *action in self.completedActions) {
    if (action.spoons < 0) {
      completedSpoons += -action.spoons;
    }
  }
  return completedSpoons;
}

- (NSInteger)plannedSpoonSources {
  NSInteger plannedSpoons = 0;
  for (DDHAction *action in self.plannedActions) {
    if (action.spoons < 0) {
      plannedSpoons += -action.spoons;
    }
  }
  return plannedSpoons;
}

- (void)updateAction:(DDHAction *)actionToUpdate {
  for (DDHAction *action in self.plannedActions) {
    if ([action.actionId isEqual:actionToUpdate.actionId]) {
      action.name = actionToUpdate.name;
      action.spoons = actionToUpdate.spoons;
      break;
    }
  }
  for (DDHAction *action in self.completedActions) {
    if ([action.actionId isEqual:actionToUpdate.actionId]) {
      action.name = actionToUpdate.name;
      action.spoons = actionToUpdate.spoons;
      break;
    }
  }
}

- (NSInteger)availableSpoons {
  return [self amountOfSpoons] - [self completedSpoons];
}

- (void)planAction:(DDHAction *)action {
  self.plannedActions = [self.plannedActions arrayByAddingObject:action];
  [self setAmountOfSpoons:self.unmodifiedAmountOfSpoons];
}

- (void)unplanAction:(DDHAction *)action {
  NSMutableArray<DDHAction *> *plannedActions = [self.plannedActions mutableCopy];
  [plannedActions removeObject:action];
  self.plannedActions = [plannedActions copy];
  [self setAmountOfSpoons:self.unmodifiedAmountOfSpoons];
}

- (void)movePlannedActionFromIndex:(NSInteger)initialIndex toFinalIndex:(NSInteger)finalIndex {
  NSMutableArray<DDHAction *> *plannedActions = [self.plannedActions mutableCopy];
  DDHAction *action = plannedActions[initialIndex];
  [plannedActions removeObjectAtIndex:initialIndex];
  [plannedActions insertObject:action atIndex:finalIndex];
  self.plannedActions = [plannedActions copy];
}

- (void)completeAction:(DDHAction *)action {
  self.completedActions = [self.completedActions arrayByAddingObject:action];
}

- (void)uncompleteAction:(DDHAction *)action {
  NSMutableArray<DDHAction *> *completedActions = [self.completedActions mutableCopy];
  [completedActions removeObject:action];
  self.completedActions = [completedActions copy];
}

- (NSArray<NSUUID *> *)idsOfCompletedActions {
  NSMutableArray<NSUUID *> *ids = [[NSMutableArray alloc] initWithCapacity:[self.completedActions count]];
  for (DDHAction *action in self.completedActions) {
    [ids addObject:action.actionId];
  }
  return [ids copy];
}

- (NSArray<NSUUID *> *)idsOfPlannedActions {
  NSMutableArray<NSUUID *> *ids = [[NSMutableArray alloc] initWithCapacity:[self.plannedActions count]];
  for (DDHAction *action in self.plannedActions) {
    [ids addObject:action.actionId];
  }
  return [ids copy];
}

- (DDHActionState)actionStateForAction:(DDHAction *)action {
  if ([self.completedActions containsObject:action]) {
    return DDHActionStateCompleted;
  } else if ([self.plannedActions containsObject:action]) {
    return DDHActionStatePlanned;
  } else {
    return DDHActionStateNone;
  }
}

- (void)resetWithDailySpoons:(NSInteger)dailySpoons {
  NSInteger carryOverSpoons = self.completedSpoons - (self.amountOfSpoons - self.carryOverSpoons);
  self.carryOverSpoons = MAX(0, carryOverSpoons);
  self.date = [NSDate now];
  self.completedActions = [[NSArray alloc] init];
  [self setAmountOfSpoons:dailySpoons];
}
@end
