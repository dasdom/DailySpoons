//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDHSettingsViewControllerProtocol <NSObject>
- (void)viewController:(UIViewController *)viewController didChangeAmountOfSpoonsTo:(NSInteger)spoons;
- (void)viewController:(UIViewController *)viewController didChangeShowStepsTo:(BOOL)showSteps;
- (void)onboardingDidResetInViewController:(UIViewController *)viewController;
- (void)doneInViewController:(UIViewController *)viewController;
@end

@interface DDHSettingsViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHSettingsViewControllerProtocol>)delegate;
@end

NS_ASSUME_NONNULL_END
