//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHAction.h"

NSString * const actionIdKey = @"actionIdKey";
NSString * const nameKey = @"nameKey";
NSString * const spoonsKey = @"spoonsKey";

@implementation DDHAction
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
    NSString *actionIdString = dictionary[actionIdKey];
    _actionId = [[NSUUID alloc] initWithUUIDString:actionIdString];
    _name = dictionary[nameKey];
    _spoons = [dictionary[spoonsKey] integerValue];
  }
  return self;
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  NSString *actionIdString = [self.actionId UUIDString];
  dictionary[actionIdKey] = actionIdString;
  dictionary[nameKey] = self.name;
  dictionary[spoonsKey] = @(self.spoons);
  return [dictionary copy];
}

- (BOOL)isEqual:(DDHAction *)object {
  if (NO == [self.actionId isEqual:object.actionId]) {
    return NO;
  }
  return YES;
}

- (NSString *)description {
  return [@[
    [NSString stringWithFormat:@"%@", self.actionId],
    self.name,
    [NSString stringWithFormat:@"%ld", (long)self.spoons]
  ] componentsJoinedByString:@", "];
}
@end
