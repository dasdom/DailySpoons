//  Created by Dominik Hauser on 26.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHActionCell.h"
#import "DDHAction.h"

@interface DDHActionCell ()
@property (nonatomic, strong) UIStackView *spoonsStackView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation DDHActionCell
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _spoonsStackView = [[UIStackView alloc] init];

    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_nameLabel setTextAlignment:NSTextAlignmentRight];

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_spoonsStackView, _nameLabel]];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [stackView setDistribution:UIStackViewDistributionFillProportionally];
    [stackView setSpacing:10];

    [[self contentView] addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
      [[stackView topAnchor] constraintEqualToAnchor:[[self contentView] topAnchor] constant:10],
      [[stackView leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor] constant:20],
      [[stackView bottomAnchor] constraintEqualToAnchor:[[self contentView] bottomAnchor] constant:-10],
      [[stackView trailingAnchor] constraintEqualToAnchor:[[self contentView] trailingAnchor] constant:-20]
    ]];
  }
  return self;
}

- (void)updateWithAction:(DDHAction *)action isCompleted:(BOOL)isCompleted {
  [self updateWithAction:action isCompleted:isCompleted isPlanned:NO];
}

- (void)updateWithAction:(DDHAction *)action isCompleted:(BOOL)isCompleted isPlanned:(BOOL)isPlanned {
  [[self nameLabel] setText:[action name]];

  NSArray<UIView *> *arrangedViews = [[self spoonsStackView] arrangedSubviews];
  [arrangedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull arrangeSubview, NSUInteger idx, BOOL * _Nonnull stop) {
    [[self spoonsStackView] removeArrangedSubview:arrangeSubview];
    [arrangeSubview removeFromSuperview];
  }];

  for (NSInteger i = 0; i < [action spoons]; i++) {
    UIImage *image;
    if (isCompleted) {
      image = [UIImage systemImageNamed:@"circle.slash"];
    } else {
      image = [UIImage systemImageNamed:@"circle"];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [imageView setTintColor:[UIColor labelColor]];
    [[self spoonsStackView] addArrangedSubview:imageView];
  }

  if (isPlanned) {
    [[self nameLabel] setTextColor:[UIColor systemGrayColor]];
    [[self spoonsStackView] setTintColor:[UIColor systemGrayColor]];
  }
}
@end
