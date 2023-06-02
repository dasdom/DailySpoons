//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "DDHAppCoordinator.h"
#import "DDHDayPlannerViewController.h"
#import "DDHViewControllerMock.h"
#import "DDHActionStoreViewController.h"
#import "DDHActionInputViewController.h"
#import "DDHAction.h"

@interface DDHAppCoordinatorTests : XCTestCase
@property (nonatomic, strong) DDHAppCoordinator *sut;
@end

@implementation DDHAppCoordinatorTests

- (void)setUp {
  _sut = [[DDHAppCoordinator alloc] init];
}

- (void)tearDown {
  [self setSut:nil];
}

- (void)test_didSelectAddButton_shouldPresentActionStore {
  DDHViewControllerMock *viewControllerMock = [[DDHViewControllerMock alloc] init];

  [(id<DDHDayPlannerViewControllerProtocol>)[self sut] didSelectAddButtonInViewController:viewControllerMock];

  UINavigationController *presentedViewController = (UINavigationController *)[viewControllerMock lastPresentedViewController];
  DDHActionStoreViewController *actionStoreViewController = (DDHActionStoreViewController *)[presentedViewController topViewController];
  XCTAssertEqualObjects([actionStoreViewController valueForKey:@"delegate"], [self sut]);
  XCTAssertEqualObjects([actionStoreViewController valueForKey:@"dataStore"], [[self sut] valueForKey:@"dataStore"]);
}

- (void)test_didSelectAddButtonWithName_shouldPresentActionInput {
  DDHViewControllerMock *viewControllerMock = [[DDHViewControllerMock alloc] init];

  [(id<DDHActionStoreViewControllerProtocol>)[self sut] didSelectAddButtonInViewController:viewControllerMock name:@"Test name"];

  UINavigationController *presentedViewController = (UINavigationController *)[viewControllerMock lastPresentedViewController];
  DDHActionInputViewController *actionInputViewController = (DDHActionInputViewController *)[presentedViewController topViewController];
  XCTAssertEqualObjects([actionInputViewController valueForKey:@"delegate"], [self sut]);
  XCTAssertEqualObjects([actionInputViewController valueForKey:@"dataStore"], [[self sut] valueForKey:@"dataStore"]);
}

- (void)test_editAction_shouldPresentActionInput {
  DDHViewControllerMock *viewControllerMock = [[DDHViewControllerMock alloc] init];
  DDHAction *action = [[DDHAction alloc] initWithName:@"name 1" spoons:1];

  [(id<DDHActionStoreViewControllerProtocol>)[self sut] editActionFromViewController:viewControllerMock action:action];

  UINavigationController *presentedViewController = (UINavigationController *)[viewControllerMock lastPresentedViewController];
  DDHActionInputViewController *actionInputViewController = (DDHActionInputViewController *)[presentedViewController topViewController];
  XCTAssertEqualObjects([actionInputViewController valueForKey:@"delegate"], [self sut]);
  XCTAssertEqualObjects([actionInputViewController valueForKey:@"dataStore"], [[self sut] valueForKey:@"dataStore"]);
  XCTAssertEqualObjects([(DDHAction *)[actionInputViewController valueForKey:@"editableAction"] actionId], [action actionId]);
}
@end
