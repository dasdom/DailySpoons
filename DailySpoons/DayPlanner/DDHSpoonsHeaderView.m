//  Created by Dominik Hauser on 30.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHSpoonsHeaderView.h"

@implementation DDHSpoonsHeaderView
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [titleLabel setText:NSLocalizedString(@"dayPlanner.spoonBudget", nil)];
    [titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
//    [titleLabel setTextColor:[UIColor systemGrayColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setAdjustsFontForContentSizeCategory:YES];
    [titleLabel setNumberOfLines:0];

    [self addSubview:titleLabel];

    [NSLayoutConstraint activateConstraints:@[
      [[titleLabel topAnchor] constraintEqualToAnchor:[self topAnchor] constant:10],
      [[titleLabel leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
      [[titleLabel bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]],
      [[titleLabel trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
    ]];
  }
  return self;
}
@end
