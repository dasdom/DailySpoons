//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHSettingsView.h"

@implementation DDHSettingsView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    [self setBackgroundColor:[UIColor systemBackgroundColor]];

    _dailySpoonsStepperLabel = [[UILabel alloc] init];
    [_dailySpoonsStepperLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    _dailySpoonsStepper = [[UIStepper alloc] init];
    [_dailySpoonsStepper setMinimumValue:1];
    [_dailySpoonsStepper setMaximumValue:24];
    [_dailySpoonsStepper setValue:1];

    UIStackView *dailySpoonsStepperStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_dailySpoonsStepperLabel, _dailySpoonsStepper]];
    [dailySpoonsStepperStackView setSpacing:10];

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[dailySpoonsStepperStackView]];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [stackView setAxis:UILayoutConstraintAxisVertical];
    [stackView setSpacing:20];

    _tipButton = [[UIButton alloc] init];
    [_tipButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_tipButton setConfiguration:[UIButtonConfiguration borderedButtonConfiguration]];
    [_tipButton setTitle:NSLocalizedString(@"settings.smallTip", nil) forState:UIControlStateNormal];
    [_tipButton setHidden:YES];

    [self addSubview:stackView];
    [self addSubview:_tipButton];

    [NSLayoutConstraint activateConstraints:@[
      [[stackView topAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] topAnchor] constant:20],
      [[stackView leadingAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] leadingAnchor] constant:20],
      [[stackView trailingAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] trailingAnchor] constant:-20],

      [[_tipButton leadingAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] leadingAnchor] constant:20],
      [[_tipButton bottomAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] bottomAnchor] constant:-20],
      [[_tipButton trailingAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] trailingAnchor] constant:-20]
    ]];
  }
  return self;
}

- (void)update {
  NSString *stepperLabelText = [NSString
                                stringWithFormat:NSLocalizedString(@"settings.dailySpoons", nil),
                                [[self dailySpoonsStepper] value]];
  [[self dailySpoonsStepperLabel] setText:stepperLabelText];
}
@end
