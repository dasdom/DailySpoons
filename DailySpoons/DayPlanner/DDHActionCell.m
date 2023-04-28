//  Created by Dominik Hauser on 26.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHActionCell.h"

@interface DDHActionCell ()
@property (nonatomic, strong) UIStackView *spoonsStackView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation DDHActionCell
- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _spoonsStackView = [[UIStackView alloc] init];

    _nameLabel = [[UILabel alloc] init];

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_spoonsStackView, _nameLabel]];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [[self contentView] addSubview:stackView];
  }
  return self;
}
@end
