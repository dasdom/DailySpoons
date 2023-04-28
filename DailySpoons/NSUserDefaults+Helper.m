//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "NSUserDefaults+Helper.h"

NSString * const ddh_dailySpoonsKey = @"ddh_dailySpoonsKey";

@implementation NSUserDefaults (Helper)
- (NSInteger)dailySpoons {
  return [self integerForKey:dailySpoonsKey];
}

- (void)setDailySpoons:(NSInteger)dailySpoons {
  [self setInteger:dailySpoons forKey:dailySpoonsKey];
}
@end
