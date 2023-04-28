//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHDayPlannerView.h"

@implementation DDHDayPlannerView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _collectionView = [[UICollectionView alloc] initWithFrame:frame
                                         collectionViewLayout:[self layout]];
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

- (UICollectionViewLayout *)layout {

  UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {

    NSCollectionLayoutSection *section;

    if (sectionIndex == 0) {
      // Budget Section
      NSCollectionLayoutDimension *oneOverSixWidthDimension = [NSCollectionLayoutDimension fractionalWidthDimension:1.0/6.0];
      NSCollectionLayoutDimension *unityHeightDimension = [NSCollectionLayoutDimension fractionalHeightDimension:1.0];

      NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:oneOverSixWidthDimension heightDimension:unityHeightDimension];

      NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];

      NSCollectionLayoutDimension *unityWidthDimension = [NSCollectionLayoutDimension fractionalWidthDimension:1.0];

      NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:unityWidthDimension heightDimension:oneOverSixWidthDimension];

      NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];

      section = [NSCollectionLayoutSection sectionWithGroup:group];
    } else if (sectionIndex == 1) {

      UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
      section = [NSCollectionLayoutSection sectionWithListConfiguration:listConfiguration layoutEnvironment:layoutEnvironment];
    }
    return section;
  }];

  return layout;
}

@end
