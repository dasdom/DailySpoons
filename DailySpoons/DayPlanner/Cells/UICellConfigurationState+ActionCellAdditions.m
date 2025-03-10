//  Created by Dominik Hauser on 09.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "UICellConfigurationState+ActionCellAdditions.h"

NSString * const UICONFIGURATIONSTATECUSTOMKEY_ACTION = @"de.dasdom.DailySpoons.action";
NSString * const UICONFIGURATIONSTATECUSTOMKEY_IS_COMPLETED = @"de.dasdom.DailySpoons.isCompleted";
NSString * const UICONFIGURATIONSTATECUSTOMKEY_IS_PLANNED = @"de.dasdom.DailySpoons.isPlanned";

@implementation UICellConfigurationState
- (DDHAction *)action {
  return [self valueForKey:UICONFIGURATIONSTATECUSTOMKEY_ACTION];
}

- (void)setAction:(DDHAction *)action {
  [self setValue:action forKey:UICONFIGURATIONSTATECUSTOMKEY_ACTION];
}

- (BOOL)isCompleted {
  return [[self valueForKey:UICONFIGURATIONSTATECUSTOMKEY_IS_COMPLETED] boolValue];
}

- (void)setIsCompleted:(BOOL)isCompleted {
  [self setValue:[NSNumber numberWithBool:isCompleted] forKey:UICONFIGURATIONSTATECUSTOMKEY_IS_PLANNED];
}

- (BOOL)isPlanned {
  return [[self valueForKey:UICONFIGURATIONSTATECUSTOMKEY_IS_COMPLETED] boolValue];
}

- (void)setIsPlanned:(BOOL)isPlanned {
  [self setValue:[NSNumber numberWithBool:isPlanned] forKey:UICONFIGURATIONSTATECUSTOMKEY_IS_PLANNED];
}
@end
