//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>

@class DDHDay;
@class DDHAction;
@class DDHHistoryEntry;

NS_ASSUME_NONNULL_BEGIN

@protocol DDHDataStoreProtocol <NSObject>
@property (nonatomic, readonly) DDHDay *day;
@property (nonatomic, readonly) NSArray<DDHAction *> *actions;
- (void)addAction:(DDHAction *)action;
- (void)removeAction:(DDHAction *)action;
- (void)saveData;
- (DDHAction *)actionForId:(NSUUID *)actionId;
- (void)createHistoryDatabaseIfNeeded;
- (BOOL)insertHistoryDay:(DDHDay *)day;
- (BOOL)deleteHistoryEntry:(DDHHistoryEntry *)entry;
- (NSArray<DDHHistoryEntry *> *)history;
@end

@interface DDHDataStore : NSObject <DDHDataStoreProtocol>
//@property (nonatomic, readonly) DDHDay *day;
//@property (nonatomic, readonly) NSArray<DDHAction *> *actions;
//- (void)addAction:(DDHAction *)action;
//- (void)removeAction:(DDHAction *)action;
//- (void)saveData;
//- (DDHAction *)actionForId:(NSUUID *)actionId;
//- (void)createHistoryDatabaseIfNeeded;
//- (BOOL)insertHistoryDay:(DDHDay *)day;
//- (NSArray<DDHHistoryEntry *> *)history;
@end

NS_ASSUME_NONNULL_END
