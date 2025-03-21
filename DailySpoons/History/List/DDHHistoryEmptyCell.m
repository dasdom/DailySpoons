//  Created by Dominik Hauser on 21.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryEmptyCell.h"

@implementation DDHHistoryEmptyCell
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"history.emptyInfo", nil);

    [self.contentView addSubview:label];

    [NSLayoutConstraint activateConstraints:@[
      [label.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor],
      [label.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
      [label.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor],
      [label.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor],
    ]];
  }
  return self;
}
@end
