//  Created by Dominik Hauser on 16.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryListView.h"

@implementation DDHHistoryListView
- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_tableView];

    [NSLayoutConstraint activateConstraints:@[
      [_tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
  }
  return self;
}
@end
