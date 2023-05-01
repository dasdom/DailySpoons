//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

@class DDHAction;
@class DDHDataStore;

NS_ASSUME_NONNULL_BEGIN

@protocol DDHActionInputViewControllerProtocol <NSObject>
- (void)addActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action;
@end

@interface DDHActionInputViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHActionInputViewControllerProtocol>)delegate dataStore:(DDHDataStore *)dataStore;
@end

NS_ASSUME_NONNULL_END
