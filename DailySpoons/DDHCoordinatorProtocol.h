//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#ifndef DDHCoordinatorProtocol_h
#define DDHCoordinatorProtocol_h

#import <UIKit/UIKit.h>

@protocol DDHCoordinatorProtocol <NSObject>
- (void)start;
- (UIViewController *)currentViewController;
@end

#endif /* DDHCoordinatorProtocol_h */
