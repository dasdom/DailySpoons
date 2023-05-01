//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHActionsHeaderView.h"

@implementation DDHActionsHeaderView
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setText:NSLocalizedString(@"Actions", nil)];
    [_nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [_nameLabel setTextColor:[UIColor systemGrayColor]];

    _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_addButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_nameLabel, _addButton]];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
      [[stackView topAnchor] constraintEqualToAnchor:[self topAnchor] constant:10],
      [[stackView leadingAnchor] constraintEqualToAnchor:[self leadingAnchor] constant:20],
      [[stackView bottomAnchor] constraintEqualToAnchor:[self bottomAnchor] constant:-10],
      [[stackView trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-7],

      [[_addButton widthAnchor] constraintEqualToConstant:44],
      [[_addButton heightAnchor] constraintEqualToAnchor:[_addButton widthAnchor]],
    ]];
  }
  return self;
}
@end
