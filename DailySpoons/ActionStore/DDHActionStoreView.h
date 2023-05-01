//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHActionStoreView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout;
@end

NS_ASSUME_NONNULL_END
