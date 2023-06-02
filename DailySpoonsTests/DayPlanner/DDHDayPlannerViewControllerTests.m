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
#import "DDHDayPlannerViewControllerProtocolMock.h"
#import "DDHDataStoreProtocolMock.h"

@interface DDHDayPlannerViewControllerTests : XCTestCase
@property (nonatomic, strong) DDHDayPlannerViewController *sut;
@property (nonatomic, readonly, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DDHDataStoreProtocolMock *dataStoreMock;
@property (nonatomic, strong) DDHDay *day;
@property (nonatomic, strong) DDHDayPlannerViewControllerProtocolMock *delegateMock;
@end

@implementation DDHDayPlannerViewControllerTests

- (void)setUp {
  DDHDayPlannerViewControllerProtocolMock *delegateMock = [[DDHDayPlannerViewControllerProtocolMock alloc] init];
  [self setDelegateMock:delegateMock];

  DDHAction *actionA = [[DDHAction alloc] initWithName:@"A" spoons:2];
  DDHAction *actionB = [[DDHAction alloc] initWithName:@"B" spoons:3];
  DDHDataStoreProtocolMock *dataStoreMock = [[DDHDataStoreProtocolMock alloc] init];
  [dataStoreMock addAction:actionA];
  [dataStoreMock addAction:actionB];
  [self setDataStoreMock:dataStoreMock];

  DDHDay *day = [[DDHDay alloc] init];
  [day setAmountOfSpoons:5];
  [day planAction:actionA];
  [day planAction:actionB];
  [self setDay:day];

  [dataStoreMock setValue:day forKey:@"day"];

  [self setSut:[[DDHDayPlannerViewController alloc] initWithDelegate:delegateMock dataStore:dataStoreMock]];
  [[self sut] loadViewIfNeeded];
}

- (void)tearDown {
  [self setSut:nil];
  [self setDelegateMock:nil];
  [self setDataStoreMock:nil];
  [self setDay:nil];
}

- (void)test_view_shouldBeDDHDayPlannerView {
  [[self sut] loadViewIfNeeded];

  XCTAssertEqualObjects([[[self sut] view] class], [DDHDayPlannerView class]);
}

- (void)test_numberOfRows_whenSectionZero_shouldBeAmountOfSpoons {
  [[self sut] loadViewIfNeeded];

  NSInteger numberOfRowsInSectionZero = [[self dataSource] collectionView:[self collectionView]
                                                   numberOfItemsInSection:0];

  XCTAssertEqual(numberOfRowsInSectionZero, 5);
}

- (void)test_numberOfRows_whenSectionOne_shouldBeAmountOfPlannedActions {
  NSInteger numberOfRowsInSectionOne = [[self dataSource] collectionView:[self collectionView]
                                                   numberOfItemsInSection:1];

  XCTAssertEqual(numberOfRowsInSectionOne, [[[self day] idsOfPlannedActions] count]);
}

- (void)test_cellForRow_whenSectionZero_shouldReturnSpoonCell {
  UICollectionViewCell *cell = [[self dataSource] collectionView:[self collectionView]
                                          cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

  XCTAssertEqualObjects([cell class], [DDHSpoonCell class]);
}

- (void)test_cellForRow_whenSectionOne_shouldReturnActionCell {
  UICollectionViewCell *cell = [[self dataSource] collectionView:[self collectionView]
                                          cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

  XCTAssertEqualObjects([cell class], [DDHActionCell class]);
}

- (void)test_reload_shouldUpdateCells {
  [self putInWindow:[self sut]];
  [[self collectionView] reloadData];
  DDHAction *action = [self firstPlannedAction];
  DDHActionCell *actionCell = (DDHActionCell *)[[self collectionView] cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
  UILabel *nameLabel = [actionCell valueForKey:@"nameLabel"];
  [action setName:@"B"];
  [[self day] updateAction:action];
  XCTAssertEqualObjects([nameLabel text], @"A");

  [[self sut] reload];

  actionCell = (DDHActionCell *)[[self collectionView] cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
  nameLabel = [actionCell valueForKey:@"nameLabel"];
  XCTAssertEqualObjects([nameLabel text], @"B");
}

- (void)test_canMoveItemAtIndexPath_whenInSectionZero_shouldReturnNo {
  BOOL canMoveItem = [[[self collectionView] dataSource] collectionView:[self collectionView] canMoveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

  XCTAssertFalse(canMoveItem);
}

- (void)test_moveItem_shouldUpdateDay {
  [[[self collectionView] dataSource] collectionView:[self collectionView] moveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] toIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];

  XCTAssertEqualObjects([[self firstPlannedAction] name], @"B");
}

// MARK: - Helper
- (UICollectionView *)collectionView {
  DDHDayPlannerView *contentView = [[self sut] performSelector:@selector(contentView)];
  return [contentView collectionView];
}

- (id<UICollectionViewDataSource>)dataSource {
  return [[self collectionView] dataSource];
}

- (void)putInWindow:(UIViewController *)viewController {
  UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
  [window setRootViewController:viewController];
  [window setHidden:NO];
}

- (DDHAction *)firstPlannedAction {
  return [[self dataStoreMock] actionForId:[[[self day] idsOfPlannedActions] firstObject]];
}

@end
