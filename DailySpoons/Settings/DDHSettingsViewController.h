//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDHSettingsViewControllerProtocol <NSObject>
- (void)dailySpoonsChangedInViewController:(UIViewController *)viewController amountOfSpoons:(NSInteger)spoons;
@end

@interface DDHSettingsViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHSettingsViewControllerProtocol>)delegate;
@end

NS_ASSUME_NONNULL_END
