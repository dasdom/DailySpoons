//  Created by Dominik Hauser on 29.05.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DDHDataStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDHDataStoreProtocolMock : NSObject <DDHDataStoreProtocol>
@property (nonatomic, readonly) DDHDay *day;
@property (nonatomic, readonly) NSArray<DDHAction *> *actions;
@end

NS_ASSUME_NONNULL_END
