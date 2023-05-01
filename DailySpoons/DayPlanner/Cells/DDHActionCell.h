//  Created by Dominik Hauser on 26.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDHAction;

NS_ASSUME_NONNULL_BEGIN

@interface DDHActionCell : UICollectionViewCell
+ (NSString *)identifier;
- (void)updateWithAction:(DDHAction *)action isCompleted:(BOOL)isCompleted;
@end

NS_ASSUME_NONNULL_END
