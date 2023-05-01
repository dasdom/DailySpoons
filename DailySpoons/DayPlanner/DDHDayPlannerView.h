//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ELEMENT_KIND_BADGE;
extern NSString * const ELEMENT_KIND_BACKGROUND;
extern NSString * const ELEMENT_KIND_SECTION_HEADER;
extern NSString * const ELEMENT_KIND_SECTION_FOOTER;
extern NSString * const ELEMENT_KIND_LAYOUT_HEADER;
extern NSString * const ELEMENT_KIND_LAYOUT_FOOTER;

@interface DDHDayPlannerView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
