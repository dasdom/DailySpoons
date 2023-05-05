//  Created by Dominik Hauser on 30.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHSpoonsFooterView.h"

@implementation DDHSpoonsFooterView
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _label = [[UILabel alloc] initWithFrame:frame];
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
    [_label setText:@"- / -"];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setNumberOfLines:0];

    [self addSubview:_label];

    [NSLayoutConstraint activateConstraints:@[
      [[_label topAnchor] constraintEqualToAnchor:[self topAnchor]],
      [[_label leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
      [[_label bottomAnchor] constraintEqualToAnchor:[self bottomAnchor] constant:-8],
      [[_label trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
    ]];
  }
  return self;
}
@end
