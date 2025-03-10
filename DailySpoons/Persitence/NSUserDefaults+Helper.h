//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ddh_dailySpoonsKey;

@interface NSUserDefaults (Helper)
- (NSInteger)dailySpoons;
- (void)setDailySpoons:(NSInteger)dailySpoons;
- (BOOL)onboardingShown;
- (void)setOnboardingShown:(BOOL)onboardingShown;
- (BOOL)showSteps;
- (void)setShowSteps:(BOOL)showSteps;
@end

NS_ASSUME_NONNULL_END
