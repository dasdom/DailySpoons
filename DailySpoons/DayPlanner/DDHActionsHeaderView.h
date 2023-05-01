//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHActionsHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *addButton;
+ (NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
