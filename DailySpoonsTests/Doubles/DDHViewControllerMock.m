//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHViewControllerMock.h"

@implementation DDHViewControllerMock

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
  [self setLastPresentedViewController:viewControllerToPresent];
}

@end
