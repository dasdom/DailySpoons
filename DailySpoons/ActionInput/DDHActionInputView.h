//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHActionInputView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *stepperLabel;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) UISegmentedControl *typeSegmentedControl;
@property (nonatomic, strong) UIButton *saveButton;
- (void)update;
@end

NS_ASSUME_NONNULL_END
