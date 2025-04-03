//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHActionStoreView.h"

@implementation DDHActionStoreView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
  if (self = [super initWithFrame:frame]) {

    self.backgroundColor = [UIColor systemBackgroundColor];

    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;

    _searchBar = [[UISearchBar alloc] init];
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_searchBar];
    [self addSubview:_collectionView];

    [NSLayoutConstraint activateConstraints:@[
      [_searchBar.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor],
      [_searchBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_searchBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

      [_collectionView.topAnchor constraintEqualToAnchor:_searchBar.bottomAnchor],
      [_collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
  }
  return self;
}
@end
