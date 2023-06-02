//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHSettingsView.h"

@implementation DDHSettingsView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    [self setBackgroundColor:[UIColor systemBackgroundColor]];

    _stepperLabel = [[UILabel alloc] init];
    [_stepperLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    _stepper = [[UIStepper alloc] init];
    [_stepper setMinimumValue:1];
    [_stepper setMaximumValue:24];
    [_stepper setValue:1];

    UIStackView *stepperStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_stepperLabel, _stepper]];
    [stepperStackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [stepperStackView setSpacing:10];

    [self addSubview:stepperStackView];

    [NSLayoutConstraint activateConstraints:@[
      [[stepperStackView topAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] topAnchor] constant:20],
      [[stepperStackView leadingAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] leadingAnchor] constant:20],
      [[stepperStackView trailingAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] trailingAnchor] constant:-20],
    ]];
  }
  return self;
}

- (void)update {
  NSString *stepperLabelText = [NSString stringWithFormat:@"Spoons: %.0lf", [[self stepper] value]];
  [[self stepperLabel] setText:stepperLabelText];
}
@end
