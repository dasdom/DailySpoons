//  Created by Dominik Hauser on 03.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHOnboardingOverlayView.h"

@interface DDHOnboardingOverlayView ()
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIStackView *arrowStackView;
@end

@implementation DDHOnboardingOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    self.backgroundColor = [UIColor.labelColor colorWithAlphaComponent:0.9];

    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.tintColor = UIColor.systemBackgroundColor;
    _arrowImageView.alpha = 0;
    [_arrowImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _arrowImageView.isAccessibilityElement = NO;

    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    _descriptionLabel.textColor = UIColor.systemBackgroundColor;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;

    _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_arrowImageView, _descriptionLabel]];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.spacing = 10;

    _nextButton = [[UIButton alloc] init];
    _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    _nextButton.configuration = UIButtonConfiguration.borderedButtonConfiguration;
    [_nextButton setTitle:NSLocalizedString(@"onboarding.next", @"") forState:UIControlStateNormal];
    _nextButton.tintColor = UIColor.systemBackgroundColor;

    [self addSubview:_stackView];
    [self addSubview:_nextButton];

    [NSLayoutConstraint activateConstraints:@[
      [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],
      [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
      [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],

      [_nextButton.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-20],
      [_nextButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
    ]];
  }
  return self;
}

- (void)updateFrameWithSuperViewFrame:(CGRect)superViewFrame yPos:(CGFloat)yPos arrowName:(NSString *)arrowName description:(NSString *)description alignment:(UIStackViewAlignment)alignment {

  [UIView animateWithDuration:0.1 animations:^{
    self.descriptionLabel.alpha = 0;
    self.arrowImageView.alpha = 0;
    self.nextButton.alpha = 0;

  } completion:^(BOOL finished) {

    self.descriptionLabel.text = description;

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

      UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:40];
      self.arrowImageView.image = [UIImage systemImageNamed:arrowName withConfiguration:configuration];

      self.stackView.alignment = alignment;

      self.frame = CGRectMake(0, yPos, superViewFrame.size.width, superViewFrame.size.height - yPos);

      self.descriptionLabel.alpha = 1;
      self.arrowImageView.alpha = 1;
      self.nextButton.alpha = 1;

    } completion:^(BOOL finished) {

    }];
  }];
}

@end
