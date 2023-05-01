//  Created by Dominik Hauser on 29.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDHDay;
@class DDHDataStore;

NS_ASSUME_NONNULL_BEGIN

@interface DDHCellRegistrationProvider : NSObject
+ (UICollectionViewCellRegistration *)spoonCellRegistration:(DDHDay *)day;
+ (UICollectionViewCellRegistration *)actionCellRegistration:(DDHDataStore *)dataStore;
@end

NS_ASSUME_NONNULL_END
