//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHDayPlannerView.h"

NSString * const ELEMENT_KIND_BADGE = @"badge-element-kind";
NSString * const ELEMENT_KIND_BACKGROUND = @"background-element-kind";
NSString * const ELEMENT_KIND_SECTION_HEADER = @"section-header-element-kind";
NSString * const ELEMENT_KIND_SECTION_FOOTER = @"section-footer-element-kind";
NSString * const ELEMENT_KIND_LAYOUT_HEADER = @"layout-header-element-kind";
NSString * const ELEMENT_KIND_LAYOUT_FOOTER = @"layout-footer-element-kind";

@implementation DDHDayPlannerView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
  if (self = [super initWithFrame:frame]) {
    _collectionView = [[UICollectionView alloc] initWithFrame:frame
                                         collectionViewLayout:layout];
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

@end
