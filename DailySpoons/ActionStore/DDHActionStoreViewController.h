//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

@class DDHDataStore;
@class DDHAction;

NS_ASSUME_NONNULL_BEGIN

@protocol DDHActionStoreViewControllerProtocol <NSObject>
- (void)addActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action;
- (void)addSelectedInViewController:(UIViewController *)viewController;
@end

@interface DDHActionStoreViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHActionStoreViewControllerProtocol>)delegate dataStore:(DDHDataStore *)dataStore;
@end

NS_ASSUME_NONNULL_END
