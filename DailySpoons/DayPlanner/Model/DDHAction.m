//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHAction.h"

NSString * const actionIdKey = @"actionIdKey";
NSString * const nameKey = @"nameKey";
NSString * const spoonsKey = @"spoonsKey";

@implementation DDHAction
- (instancetype)init {
  if (self = [super init]) {
    _actionId = [NSUUID UUID];
  }
  return self;
}

- (instancetype)initWithName:(NSString *)name spoons:(NSInteger)spoons {
  if (self = [super init]) {
    _actionId = [NSUUID UUID];
    _name = name;
    _spoons = spoons;
  }
  return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    NSString *actionIdString = [dictionary valueForKey:actionIdKey];
    _actionId = [[NSUUID alloc] initWithUUIDString:actionIdString];
    _name = [dictionary valueForKey:nameKey];
    _spoons = [[dictionary valueForKey:spoonsKey] integerValue];
  }
  return self;
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  NSString *actionIdString = [[self actionId] UUIDString];
  [dictionary setObject:actionIdString forKey:actionIdKey];
  [dictionary setObject:[self name] forKey:nameKey];
  [dictionary setObject:[NSNumber numberWithInteger:[self spoons]] forKey:spoonsKey];
  return [dictionary copy];
}

- (BOOL)isEqual:(DDHAction *)object {
  if (NO == [[self actionId] isEqual:[object actionId]]) {
    return NO;
  }
  return YES;
}
@end
