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

    [self setBackgroundColor:[[UIColor labelColor] colorWithAlphaComponent:0.9]];

    _arrowImageView = [[UIImageView alloc] init];
    [_arrowImageView setTintColor:[UIColor systemBackgroundColor]];
    [_arrowImageView setAlpha:0];
    [_arrowImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_arrowImageView setIsAccessibilityElement:NO];

    _descriptionLabel = [[UILabel alloc] init];
    [_descriptionLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    [_descriptionLabel setTextColor:[UIColor systemBackgroundColor]];
    [_descriptionLabel setNumberOfLines:0];
    [_descriptionLabel setTextAlignment:NSTextAlignmentCenter];

    _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_arrowImageView, _descriptionLabel]];
    [_stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_stackView setAxis:UILayoutConstraintAxisVertical];
    [_stackView setAlignment:UIStackViewAlignmentCenter];
    [_stackView setSpacing:10];

    _nextButton = [[UIButton alloc] init];
    [_nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_nextButton setConfiguration:[UIButtonConfiguration borderedButtonConfiguration]];
    [_nextButton setTitle:NSLocalizedString(@"onboarding.next", @"") forState:UIControlStateNormal];
    [_nextButton setTintColor:[UIColor systemBackgroundColor]];

    [self addSubview:_stackView];
    [self addSubview:_nextButton];

    [NSLayoutConstraint activateConstraints:@[
      [[_stackView topAnchor] constraintEqualToAnchor:[self topAnchor] constant:20],
      [[_stackView leadingAnchor] constraintEqualToAnchor:[self leadingAnchor] constant:20],
      [[_stackView trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-20],

      [[_nextButton bottomAnchor] constraintEqualToAnchor:[[self safeAreaLayoutGuide] bottomAnchor] constant:-20],
      [[_nextButton centerXAnchor] constraintEqualToAnchor:[self centerXAnchor]]
    ]];
  }
  return self;
}

- (void)updateFrameWithSuperViewFrame:(CGRect)superViewFrame yPos:(CGFloat)yPos arrowName:(NSString *)arrowName description:(NSString *)description alignment:(UIStackViewAlignment)alignment {

  [UIView animateWithDuration:0.1 animations:^{
    [[self descriptionLabel] setAlpha:0];
    [[self arrowImageView] setAlpha:0];
    [[self nextButton] setAlpha:0];
  } completion:^(BOOL finished) {
    [[self descriptionLabel] setText:description];

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

      UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:40];
      [[self arrowImageView] setImage:[UIImage systemImageNamed:arrowName withConfiguration:configuration]];

      [[self stackView] setAlignment:alignment];

      [self setFrame:CGRectMake(0, yPos, superViewFrame.size.width, superViewFrame.size.height - yPos)];

      [[self descriptionLabel] setAlpha:1];
      [[self arrowImageView] setAlpha:1];
      [[self nextButton] setAlpha:1];

    } completion:^(BOOL finished) {

    }];
  }];
}

@end
