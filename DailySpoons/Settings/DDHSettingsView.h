//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHSettingsView : UIView
@property (nonatomic, strong) UILabel *dailySpoonsStepperLabel;
@property (nonatomic, strong) UIStepper *dailySpoonsStepper;
@property (nonatomic, strong) UIButton *resetOnboardingButton;
- (void)update;
@end

NS_ASSUME_NONNULL_END
