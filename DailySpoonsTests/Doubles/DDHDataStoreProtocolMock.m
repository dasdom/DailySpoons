//  Created by Dominik Hauser on 29.05.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHDataStoreProtocolMock.h"
#import "DDHAction.h"
#import "DDHDay.h"

@interface DDHDataStoreProtocolMock ()
@property (nonatomic, readwrite) DDHDay *day;
@property (nonatomic, readwrite) NSArray<DDHAction *> *actions;
@end

@implementation DDHDataStoreProtocolMock

- (instancetype)init {
  if (self = [super init]) {
    _day = [[DDHDay alloc] init];
    _actions = [[NSArray alloc] init];
  }
  return self;
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

- (void)addAction:(nonnull DDHAction *)action {
  [self setActions:[[self actions] arrayByAddingObject:action]];
}

- (void)removeAction:(nonnull DDHAction *)action {
  NSMutableArray<DDHAction *> *actions = [[self actions] mutableCopy];
  [actions removeObject:action];
  [self setActions:[actions copy]];
}

- (void)saveData {
  
}

@end
