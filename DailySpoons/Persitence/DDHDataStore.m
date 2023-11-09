//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHDataStore.h"
#import "DDHDay.h"
#import "DDHAction.h"

@interface DDHDataStore ()
@property (nonatomic, readwrite) DDHDay *day;
@property (nonatomic, readwrite) NSArray<DDHAction *> *actions;
@end

@implementation DDHDataStore
- (instancetype)init {
  if (self = [super init]) {
    _actions = [self loadActions];
    _day = [self loadDay];
  }
  return self;
}

- (void)addAction:(DDHAction *)action {
  [self setActions:[[self actions] arrayByAddingObject:action]];
  [self saveActions:[self actions]];
}

- (void)removeAction:(DDHAction *)action {
  NSMutableArray<DDHAction *> *actions = [[self actions] mutableCopy];
  [actions removeObject:action];
  [self setActions:[actions copy]];
}

- (void)saveData {
  [self saveDay:[self day]];
  [self saveActions:[self actions]];
}

- (DDHAction *)actionForId:(NSUUID *)actionId {
  __block DDHAction *foundAction;
  [[self actions] enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([[action actionId] isEqual:actionId]) {
      foundAction = action;
      *stop = YES;
    }
  }];
  return foundAction;
}

// MARK: - private methods
- (NSArray<DDHAction *> *)loadActions {
  NSData *data = [[NSData alloc] initWithContentsOfURL:[self actionsURL]];
  if (data != nil) {
    NSError *jsonError = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    __block NSMutableArray<DDHAction *> *actions = [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];
    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
      DDHAction *action = [[DDHAction alloc] initWithDictionary:dictionary];
      [actions addObject:action];
    }];
    NSLog(@"JSON error: %@", jsonError);
    return [actions copy];
  } else {
    return [[NSArray alloc] init];
  }
}

- (NSURL *)dayURL {
  NSURL *sharedURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.de.dasdom.dailyspoons"];
//  NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
  NSURL *url = [sharedURL URLByAppendingPathComponent:@"day.json"];
  return url;
}

- (NSURL *)actionsURL {
  NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
  NSURL *url = [documentsURL URLByAppendingPathComponent:@"actions.json"];
  NSLog(@"url: %@", url);
  return url;
}

- (DDHDay *)loadDay {
  NSData *data = [[NSData alloc] initWithContentsOfURL:[self dayURL]];
  if (data != nil) {
    NSError *jsonError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    NSLog(@"JSON error: %@", jsonError);
    return [[DDHDay alloc] initWithDictionary:jsonDictionary];
  } else {
    return [[DDHDay alloc] init];
  }
}

- (void)saveDay:(DDHDay *)day {
  NSError *jsonError = nil;
  NSData *data = [NSJSONSerialization dataWithJSONObject:[day dictionary] options:0 error:&jsonError];
  NSLog(@"JSON error: %@", jsonError);
  [data writeToURL:[self dayURL] atomically:YES];
}

- (void)saveActions:(NSArray<DDHAction *> *)actions {
  NSError *jsonError = nil;
  __block NSMutableArray<NSDictionary *> *jsonArray = [[NSMutableArray alloc] initWithCapacity:[actions count]];
  [actions enumerateObjectsUsingBlock:^(DDHAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
    [jsonArray addObject:[action dictionary]];
  }];

  NSData *data = [NSJSONSerialization dataWithJSONObject:jsonArray options:0 error:&jsonError];
  if (jsonError != nil) {
    NSLog(@"JSON error: %@", jsonError);
  }
  [data writeToURL:[self actionsURL] atomically:YES];
}

@end
