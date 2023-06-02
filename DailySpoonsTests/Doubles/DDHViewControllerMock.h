//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHViewControllerMock : UIViewController
@property (nonatomic, strong) UIViewController *lastPresentedViewController;
@end

NS_ASSUME_NONNULL_END
