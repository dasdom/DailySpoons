//  Created by Dominik Hauser on 01.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHActionInputViewControllerProtocolMock.h"

@implementation DDHActionInputViewControllerProtocolMock

- (void)addActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action {
  [self setLastAddedAction:action];
}

- (void)editDoneInViewController:(UIViewController *)viewController action:(DDHAction *)action {
  [self setLastEditedAction:action];
}

@end
