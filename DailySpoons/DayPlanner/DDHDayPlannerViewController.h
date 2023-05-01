//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDHDataStore;
@class DDHDay;

NS_ASSUME_NONNULL_BEGIN

@protocol DDHDayPlannerViewControllerProtocol <NSObject>
- (void)addSelectedInViewController:(UIViewController *)viewController;
@end

@interface DDHDayPlannerViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHDayPlannerViewControllerProtocol>)delegate dataStore:(DDHDataStore *)dataStore;
- (void)updateWithDay:(DDHDay *)day;
@end

NS_ASSUME_NONNULL_END
