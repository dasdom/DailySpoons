//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHActionStoreView.h"

@implementation DDHActionStoreView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
  if (self = [super initWithFrame:frame]) {

    [self setBackgroundColor:[UIColor systemBackgroundColor]];

    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addSubview:_collectionView];

    [NSLayoutConstraint activateConstraints:@[
      [[_collectionView topAnchor] constraintEqualToAnchor:[self topAnchor]],
      [[_collectionView leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
      [[_collectionView bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]],
      [[_collectionView trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
    ]];
  }
  return self;
}

//- (UICollectionViewLayout *)layout {
//  UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
//  listConfiguration.trailingSwipeActionsConfigurationProvider = ^UISwipeActionsConfiguration * (NSIndexPath *indexPath) {
//    return [UISwipeActionsConfiguration configurationWithActions:@[
//      [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(@"Edit", nil) handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//
//    }]
//    ]];
//  };
//  return [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
//}

@end
