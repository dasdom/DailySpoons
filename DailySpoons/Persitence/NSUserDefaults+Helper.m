//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "NSUserDefaults+Helper.h"

NSString * const ddh_dailySpoonsKey = @"ddh_dailySpoonsKey";
NSString * const ddh_onboardingShown = @"ddh_onboardingShown";
NSString * const ddh_showSteps = @"ddh_showSteps";

@implementation NSUserDefaults (Helper)
- (NSInteger)dailySpoons {
  return [self integerForKey:ddh_dailySpoonsKey];
}

- (void)setDailySpoons:(NSInteger)dailySpoons {
  [self setInteger:dailySpoons forKey:ddh_dailySpoonsKey];
}

- (BOOL)onboardingShown {
  return [self boolForKey:ddh_onboardingShown];
}

- (void)setOnboardingShown:(BOOL)onboardingShown {
  [self setBool:onboardingShown forKey:ddh_onboardingShown];
}

- (BOOL)showSteps {
  return [self boolForKey:ddh_showSteps];
}

- (void)setShowSteps:(BOOL)showSteps {
  [self setBool:showSteps forKey:ddh_showSteps];
}
@end
