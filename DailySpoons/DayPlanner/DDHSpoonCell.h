//  Created by Dominik Hauser on 26.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDHActionState.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDHSpoonCell : UICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateCellWithActionState:(DDHActionState)actionState;
@end

NS_ASSUME_NONNULL_END
