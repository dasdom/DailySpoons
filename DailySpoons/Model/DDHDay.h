//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DDHActionState.h"

@class DDHAction;

NS_ASSUME_NONNULL_BEGIN

@interface DDHDay : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger unmodifiedAmountOfSpoons;
@property (nonatomic, assign) NSInteger amountOfSpoons;
@property (nonatomic, assign) NSInteger carryOverSpoons;
@property (nonatomic, strong) NSArray<DDHAction *> *completedActions;
@property (nonatomic, strong) NSArray<NSUUID *> *spoonsIdentifiers;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initAmountOfSpoons:(NSInteger)amountOfSpoons plannedActions:(NSArray<DDHAction *> *)plannedActions completedActions:(NSArray<DDHAction *> *)completedActions;
- (NSInteger)completedSpoons;
- (NSInteger)plannedSpoons;
- (NSInteger)completedSpoonSources;
- (NSInteger)availableSpoons;
- (NSDictionary *)dictionary;
- (void)planAction:(DDHAction *)action;
- (void)unplanAction:(DDHAction *)action;
- (void)movePlannedActionFromIndex:(NSInteger)initialIndex toFinalIndex:(NSInteger)finalIndex;
- (void)completeAction:(DDHAction *)action;
- (void)uncompleteAction:(DDHAction *)action;
- (void)updateAction:(DDHAction *)action;
- (NSArray<NSUUID *> *)idsOfPlannedActions;
- (NSArray<NSUUID *> *)idsOfCompletedActions;
- (DDHActionState)actionStateForAction:(DDHAction *)action;
- (void)resetWithDailySpoons:(NSInteger)dailySpoons;
@end

NS_ASSUME_NONNULL_END
