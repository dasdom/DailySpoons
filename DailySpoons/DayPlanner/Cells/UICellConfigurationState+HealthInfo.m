//  Created by Dominik Hauser on 10.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "UICellConfigurationState+HealthInfo.h"

NSString * const UICONFIGURATIONSTATECUSTOMKEY_STEPSYESTERDAY = @"de.dasdom.DailySpoons.stepsYesterday";
NSString * const UICONFIGURATIONSTATECUSTOMKEY_STEPSTODAY = @"de.dasdom.DailySpoons.stepsToday";

@implementation UICellConfigurationState (HealthInfo)
- (NSInteger)stepsYesterday {
  return [[self valueForKey:UICONFIGURATIONSTATECUSTOMKEY_STEPSYESTERDAY] integerValue];
}

- (void)setStepsYesterday:(NSInteger )steps {
  [self setValue:@(steps) forKey:UICONFIGURATIONSTATECUSTOMKEY_STEPSYESTERDAY];
}

- (NSInteger)stepsToday {
  return [[self valueForKey:UICONFIGURATIONSTATECUSTOMKEY_STEPSTODAY] integerValue];
}

- (void)setStepsToday:(NSInteger )steps {
  [self setValue:@(steps) forKey:UICONFIGURATIONSTATECUSTOMKEY_STEPSTODAY];
}
@end
