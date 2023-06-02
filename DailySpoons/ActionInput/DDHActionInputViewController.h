//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DDHDataStore.h"

@class DDHAction;

@protocol DDHActionInputViewControllerProtocol <NSObject>
- (void)addActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action;
- (void)editDoneInViewController:(UIViewController *)viewController action:(DDHAction *)action;
@end

@interface DDHActionInputViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHActionInputViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore editableAction:(DDHAction *)editableAction;
- (instancetype)initWithDelegate:(id<DDHActionInputViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore name:(NSString *)name;
- (instancetype)initWithDelegate:(id<DDHActionInputViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore;
@end
