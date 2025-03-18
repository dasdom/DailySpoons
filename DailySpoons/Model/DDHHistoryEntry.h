//  Created by Dominik Hauser on 14.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHHistoryEntry : NSObject
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger amountOfSpoons;
@property (nonatomic) NSInteger plannedSpoons;
@property (nonatomic) NSInteger completedSpoons;
@property (nonatomic) NSString *completedActionsString;
- (instancetype)initUUID:(NSUUID *)uuid date:(NSDate *)date amountOfSpoons:(NSInteger)amountOfSpoons plannedSpoons:(NSInteger)plannedSpoons completedSpoons:(NSInteger)completedSpoons completedActionsString:(NSString *)completedActionsString;
@end

NS_ASSUME_NONNULL_END
