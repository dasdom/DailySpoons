//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHActionStoreViewControllerProtocolMock.h"

@implementation DDHActionStoreViewControllerProtocolMock

- (void)addActionFromViewController:(nonnull UIViewController *)viewController action:(nonnull DDHAction *)action {
  [self setLastAddedAction:action];
}

- (void)didSelectAddButtonInViewController:(nonnull UIViewController *)viewController name:(nonnull NSString *)name {
}

- (void)editActionFromViewController:(nonnull UIViewController *)viewController action:(nonnull DDHAction *)action {
  [self setLastEditedAction:action];
}

@end
