//  Created by Dominik Hauser on 26.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDHActionState.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDHSpoonCell : UICollectionViewCell
+ (NSString *)identifier;
- (void)updateWithActionState:(DDHActionState)actionState;
@end

NS_ASSUME_NONNULL_END
