//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>

@class DDHAction;

NS_ASSUME_NONNULL_BEGIN

@interface DDHDay : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger amountOfSpoons;
@property (nonatomic, assign) NSInteger carryOverSpoons;

- (NSInteger)completedSpoons;
- (NSInteger)plannedSpoons;
- (NSInteger)availableSpoons;
@end

NS_ASSUME_NONNULL_END
