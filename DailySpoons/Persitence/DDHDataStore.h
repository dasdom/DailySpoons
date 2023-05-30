//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>

@class DDHDay;
@class DDHAction;

NS_ASSUME_NONNULL_BEGIN

@protocol DDHDataStoreProtocol <NSObject>
@property (nonatomic, readonly) DDHDay *day;
@property (nonatomic, readonly) NSArray<DDHAction *> *actions;
- (void)addAction:(DDHAction *)action;
- (void)removeAction:(DDHAction *)action;
- (void)saveData;
- (DDHAction *)actionForId:(NSUUID *)actionId;
@end

@interface DDHDataStore : NSObject <DDHDataStoreProtocol>
@property (nonatomic, readonly) DDHDay *day;
@property (nonatomic, readonly) NSArray<DDHAction *> *actions;
- (void)addAction:(DDHAction *)action;
- (void)removeAction:(DDHAction *)action;
- (void)saveData;
- (DDHAction *)actionForId:(NSUUID *)actionId;
@end

NS_ASSUME_NONNULL_END
