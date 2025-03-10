//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHSettingsView.h"

@implementation DDHSettingsView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    self.backgroundColor = UIColor.systemBackgroundColor;

    _dailySpoonsStepperLabel = [[UILabel alloc] init];
    [_dailySpoonsStepperLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    _dailySpoonsStepper = [[UIStepper alloc] init];
    _dailySpoonsStepper.minimumValue = 1;
    _dailySpoonsStepper.maximumValue = 24;
    _dailySpoonsStepper.value = 1;

    UIStackView *dailySpoonsStepperStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_dailySpoonsStepperLabel, _dailySpoonsStepper]];
    dailySpoonsStepperStackView.spacing = 10;


    UILabel *showStepsLabel = [[UILabel alloc] init];
    showStepsLabel.text = NSLocalizedString(@"settings.showSteps", nil);

    _showSteps = [[UISwitch alloc] init];

    UIStackView *showStepsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[showStepsLabel, _showSteps]];
    showStepsStackView.spacing = 10;

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[dailySpoonsStepperStackView, showStepsStackView]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 20;

    _tipButton = [[UIButton alloc] init];
    _tipButton.translatesAutoresizingMaskIntoConstraints = NO;
    _tipButton.configuration = [UIButtonConfiguration borderedButtonConfiguration];
    [_tipButton setTitle: NSLocalizedString(@"settings.smallTip", nil) forState:UIControlStateNormal];
    _tipButton.hidden = YES;

    [self addSubview:stackView];
    [self addSubview:_tipButton];

    [NSLayoutConstraint activateConstraints:@[
      [stackView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:20],
      [stackView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:20],
      [stackView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-20],

      [_tipButton.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:20],
      [_tipButton.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-20],
      [_tipButton.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-20]
    ]];
  }
  return self;
}

- (void)update {
  NSString *stepperLabelText = [NSString
                                stringWithFormat:NSLocalizedString(@"settings.dailySpoons", nil),
                                self.dailySpoonsStepper.value];
  self.dailySpoonsStepperLabel.text = stepperLabelText;
}
@end
