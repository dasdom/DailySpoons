//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DDHDayPlannerView.h"

@interface DDHDayPlannerViewTests : XCTestCase
@property (nonatomic, strong) DDHDayPlannerView *sut;
@end

@implementation DDHDayPlannerViewTests

- (void)setUp {
  [self setSut:[[DDHDayPlannerView alloc] init]];
}

- (void)tearDown {
  [self setSut:nil];
}

- (void)test_shouldHaveCollectionViewAsSubview {
  UICollectionView *collectionView = [[self sut] collectionView];
  XCTAssertTrue([collectionView isDescendantOfView:[self sut]]);
}

@end
