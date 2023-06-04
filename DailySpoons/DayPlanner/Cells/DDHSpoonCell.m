//  Created by Dominik Hauser on 26.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHSpoonCell.h"

@interface DDHSpoonCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DDHSpoonCell
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _imageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"circle.fill"]];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_imageView setContentMode:UIViewContentModeCenter];
    [_imageView setTintColor:[UIColor labelColor]];

    [[self contentView] addSubview:_imageView];

    [NSLayoutConstraint activateConstraints:@[
      [[_imageView topAnchor] constraintEqualToAnchor:[[self contentView] topAnchor]],
      [[_imageView leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor]],
      [[_imageView bottomAnchor] constraintEqualToAnchor:[[self contentView] bottomAnchor]],
      [[_imageView trailingAnchor] constraintEqualToAnchor:[[self contentView] trailingAnchor]]
    ]];
  }
  return self;
}

- (void)updateWithActionState:(DDHActionState)actionState {
  switch (actionState) {
    case DDHActionStatePlanned:
      [[self imageView] setImage:[UIImage systemImageNamed:@"circle"]];
      break;
    case DDHActionStateCompleted:
      [[self imageView] setImage:[UIImage systemImageNamed:@"circle.slash"]];
      break;
    default:
      [[self imageView] setImage:[UIImage systemImageNamed:@"circle.fill"]];
      break;
  }
}
@end
