//  Created by Dominik Hauser on 01.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DDHActionInputViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDHActionInputViewControllerProtocolMock : NSObject <DDHActionInputViewControllerProtocol>
@property (strong, nonatomic) DDHAction *lastAddedAction;
@property (strong, nonatomic) DDHAction *lastEditedAction;
@end

NS_ASSUME_NONNULL_END
