//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DDHDayPlannerViewController.h"
#import "DDHDayPlannerView.h"

@interface DDHDayPlannerViewControllerTests : XCTestCase
@property (nonatomic, strong) DDHDayPlannerViewController *sut;
@end

@implementation DDHDayPlannerViewControllerTests

- (void)setUp {
  [self setSut:[[DDHDayPlannerViewController alloc] init]];
  [[self sut] loadViewIfNeeded];
}

- (void)tearDown {
  [self setSut:nil];
}

- (void)test_view_shouldBeDDHDayPlannerView {
  XCTAssertEqualObjects([[[self sut] view] class], [DDHDayPlannerView class]);
}

@end
