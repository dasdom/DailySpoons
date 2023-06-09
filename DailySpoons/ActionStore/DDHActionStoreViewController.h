//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DDHDataStore.h"

@class DDHAction;

NS_ASSUME_NONNULL_BEGIN

@protocol DDHActionStoreViewControllerProtocol <NSObject>
- (void)addActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action;
- (void)didSelectAddButtonInViewController:(UIViewController *)viewController name:(NSString *)name;
- (void)editActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action;
@end

@interface DDHActionStoreViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHActionStoreViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore;
- (void)reload;
@end

NS_ASSUME_NONNULL_END
