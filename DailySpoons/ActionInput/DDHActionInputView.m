//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHActionInputView.h"

@interface DDHActionInputView ()
@end

@implementation DDHActionInputView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    [self setBackgroundColor:[UIColor systemBackgroundColor]];

    _textField = [[UITextField alloc] init];
    [_textField setPlaceholder:NSLocalizedString(@"Action name", nil)];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];

    _stepperLabel = [[UILabel alloc] init];
    [_stepperLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    _stepper = [[UIStepper alloc] init];
    [_stepper setMinimumValue:1];
    [_stepper setMaximumValue:24];
    [_stepper setValue:1];

    UIStackView *stepperStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_stepperLabel, _stepper]];
    [stepperStackView setSpacing:10];

    UIButtonConfiguration *buttonConfiguration = [UIButtonConfiguration filledButtonConfiguration];
    _saveButton = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:nil];
    [_saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_textField, stepperStackView, _saveButton]];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [stackView setAxis:UILayoutConstraintAxisVertical];
    [stackView setSpacing:10];

    [self addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
      [[stackView topAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] topAnchor] constant:20],
      [[stackView leadingAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] leadingAnchor] constant:20],
      [[stackView trailingAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] trailingAnchor] constant:-20],
    ]];

    [self update];
  }
  return self;
}

- (void)update {
  NSString *stepperLabelText = [NSString stringWithFormat:@"Spoons: %.0lf", [[self stepper] value]];
  [[self stepperLabel] setText:stepperLabelText];
}

@end
