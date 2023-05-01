//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DDHDayPlannerViewController.h"
#import "DDHDayPlannerView.h"
#import "DDHDay.h"
#import "DDHSpoonCell.h"
#import "DDHAction.h"
#import "DDHActionCell.h"

@interface DDHDayPlannerViewControllerTests : XCTestCase
@property (nonatomic, strong) DDHDayPlannerViewController *sut;
@property (nonatomic, readonly, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DDHDay *day;
@end

@implementation DDHDayPlannerViewControllerTests

- (void)setUp {
  [self setSut:[[DDHDayPlannerViewController alloc] init]];
  DDHDay *day = [[DDHDay alloc] init];
  [day setAmountOfSpoons:5];
  [day planAction:[[DDHAction alloc] init]];
  [[self sut] setValue:day forKey:@"day"];
  [[self sut] loadViewIfNeeded];
}

- (void)tearDown {
  [self setSut:nil];
}

- (void)test_view_shouldBeDDHDayPlannerView {
  XCTAssertEqualObjects([[[self sut] view] class], [DDHDayPlannerView class]);
}

- (void)test_numberOfRows_whenFirstSection_shouldBeAmountOfSpoons {
  NSInteger numberOfRowsInSectionZero = [[self dataSource] collectionView:[self collectionView] numberOfItemsInSection:0];

  XCTAssertEqual(numberOfRowsInSectionZero, 5);
}

- (void)test_cellForRow_whenFirstSection_shouldReturnSpoonCell {
  UICollectionViewCell *cell = [[self dataSource] collectionView:[self collectionView] cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

  XCTAssertEqualObjects([cell class], [DDHSpoonCell class]);
}

- (void)test_cellForRow_whenSecondSection_shouldReturnActionCell {
  UICollectionViewCell *cell = [[self dataSource] collectionView:[self collectionView] cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

  XCTAssertEqualObjects([cell class], [DDHActionCell class]);
}

// MARK: - Helper
- (UICollectionView *)collectionView {
  DDHDayPlannerView *contentView = [[self sut] performSelector:@selector(contentView)];
  return [contentView collectionView];
}

- (id<UICollectionViewDataSource>)dataSource {
  return [[self collectionView] dataSource];
}

@end
