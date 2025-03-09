//  Created by Dominik Hauser on 03.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHCollectionViewLayoutProvider.h"
#import "DDHSpoonsBackgroundView.h"

NSString * const ELEMENT_KIND_BADGE = @"badge-element-kind";
NSString * const ELEMENT_KIND_BACKGROUND = @"background-element-kind";
NSString * const ELEMENT_KIND_SECTION_HEADER = @"section-header-element-kind";
NSString * const ELEMENT_KIND_SECTION_FOOTER = @"section-footer-element-kind";
NSString * const ELEMENT_KIND_LAYOUT_HEADER = @"layout-header-element-kind";
NSString * const ELEMENT_KIND_LAYOUT_FOOTER = @"layout-footer-element-kind";

@implementation DDHCollectionViewLayoutProvider
+ (UICollectionViewLayout *)layoutWithTrailingSwipeActionsConfigurationProvider:(UICollectionLayoutListSwipeActionsConfigurationProvider)trailingSwipeActionsConfigurationProvider {

  UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {

    NSCollectionLayoutSection *section;

    if (sectionIndex == 0) {
      // Budget Section
      NSCollectionLayoutDimension *oneOverSixWidthDimension = [NSCollectionLayoutDimension fractionalWidthDimension:1.0/6.0];
      NSCollectionLayoutDimension *unityHeightDimension = [NSCollectionLayoutDimension fractionalHeightDimension:1.0];

      NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:oneOverSixWidthDimension heightDimension:unityHeightDimension];

      NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];

      NSCollectionLayoutDimension *unityWidthDimension = [NSCollectionLayoutDimension fractionalWidthDimension:1.0];
      NSCollectionLayoutDimension *automaticHeightDimension = [NSCollectionLayoutDimension estimatedDimension:20];

      NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:unityWidthDimension heightDimension:automaticHeightDimension];

      NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];

      section = [NSCollectionLayoutSection sectionWithGroup:group];
      section.interGroupSpacing = 10;

      NSCollectionLayoutSize *headerFooterSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension estimatedDimension:30.0]];

      NSCollectionLayoutBoundarySupplementaryItem *sectionHeader = [NSCollectionLayoutBoundarySupplementaryItem boundarySupplementaryItemWithLayoutSize: headerFooterSize elementKind:ELEMENT_KIND_SECTION_HEADER alignment: NSRectAlignmentTop];

      NSCollectionLayoutBoundarySupplementaryItem *sectionFooter = [NSCollectionLayoutBoundarySupplementaryItem boundarySupplementaryItemWithLayoutSize: headerFooterSize elementKind:ELEMENT_KIND_SECTION_FOOTER alignment: NSRectAlignmentBottom];

      [section setBoundarySupplementaryItems: @[sectionHeader, sectionFooter]];

      NSCollectionLayoutDecorationItem *sectionBackground = [NSCollectionLayoutDecorationItem backgroundDecorationItemWithElementKind:ELEMENT_KIND_BACKGROUND];

      [section setDecorationItems: @[sectionBackground]];

      [section setContentInsets:NSDirectionalEdgeInsetsMake(10, 20, 10, 20)];

    } else if (sectionIndex == 1) {

      UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
      [listConfiguration setHeaderMode:UICollectionLayoutListHeaderModeSupplementary];
      [listConfiguration setTrailingSwipeActionsConfigurationProvider:trailingSwipeActionsConfigurationProvider];
      section = [NSCollectionLayoutSection sectionWithListConfiguration:listConfiguration layoutEnvironment:layoutEnvironment];
    }
    return section;
  }];

  [layout registerClass:[DDHSpoonsBackgroundView class] forDecorationViewOfKind:ELEMENT_KIND_BACKGROUND];

  return layout;
}
@end
