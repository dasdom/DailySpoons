//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DDHActionStoreViewController.h"

@class DDHAction;

NS_ASSUME_NONNULL_BEGIN

@interface DDHActionStoreViewControllerProtocolMock : NSObject <DDHActionStoreViewControllerProtocol>
@property (strong, nonatomic) DDHAction *lastAddedAction;
@property (strong, nonatomic) DDHAction *lastEditedAction;
@end

NS_ASSUME_NONNULL_END
