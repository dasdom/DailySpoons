//  Created by Dominik Hauser on 10.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHHealthDataCell : UICollectionViewCell
+ (NSString *)identifier;
- (void)updateWithStepsYesterday:(NSInteger)stepsYesterday today:(NSInteger)stepsToday;
@end

NS_ASSUME_NONNULL_END
