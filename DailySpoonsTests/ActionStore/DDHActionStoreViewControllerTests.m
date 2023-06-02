//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "DDHActionStoreViewController.h"
#import "DDHActionStoreViewControllerProtocolMock.h"
#import "DDHDataStoreProtocolMock.h"
#import "DDHActionStoreView.h"
#import "DDHAction.h"
#import "DDHDay.h"

@interface DDHActionStoreViewControllerTests : XCTestCase
@property (strong, nonatomic) DDHActionStoreViewController *sut;
@property (strong, nonatomic) DDHActionStoreViewControllerProtocolMock *delegateMock;
@property (strong, nonatomic) DDHDataStoreProtocolMock *dataStoreMock;
@end

@implementation DDHActionStoreViewControllerTests

- (void)setUp {
  _delegateMock = [[DDHActionStoreViewControllerProtocolMock alloc] init];
  _dataStoreMock = [[DDHDataStoreProtocolMock alloc] init];
  _sut = [[DDHActionStoreViewController alloc] initWithDelegate:_delegateMock dataStore:_dataStoreMock];
  [_sut loadViewIfNeeded];
}

- (void)tearDown {
  [self setSut:nil];
  [self setDelegateMock:nil];
  [self setDataStoreMock:nil];
}

- (void)test_view_shouldBeActionStoreView {
  XCTAssertEqualObjects([[[self sut] view] class], [DDHActionStoreView class]);
}

- (void)test_searchBar_shouldHaveDelegate {
  DDHActionStoreView *actionStoreView = (DDHActionStoreView *)[[self sut] view];
  XCTAssertNotNil([[actionStoreView searchBar] delegate]);
}

- (void)test_searchBarTextDidChange_whenActionsUnplanned_shouldFilterActions {
  DDHAction *action1 = [[DDHAction alloc] initWithName:@"name 1" spoons:1];
  DDHAction *action2 = [[DDHAction alloc] initWithName:@"dummy" spoons:2];
  DDHAction *action3 = [[DDHAction alloc] initWithName:@"name 3" spoons:3];
  [[self dataStoreMock] addAction:action1];
  [[self dataStoreMock] addAction:action2];
  [[self dataStoreMock] addAction:action3];
  _sut = [[DDHActionStoreViewController alloc] initWithDelegate:[self delegateMock] dataStore:[self dataStoreMock]];
  DDHActionStoreView *actionStoreView = (DDHActionStoreView *)[[self sut] view];

  [[[actionStoreView searchBar] delegate] searchBar:[actionStoreView searchBar] textDidChange:@"name"];

  UICollectionView *collectionView = [actionStoreView collectionView];
  NSInteger numberOfUnplannedFilteredItems = [[collectionView dataSource] collectionView:collectionView numberOfItemsInSection:0];
  XCTAssertEqual(numberOfUnplannedFilteredItems, 2);
}

- (void)test_searchBarTextDidChange_whenActionsPlanned_shouldFilterActions {
  DDHAction *action1 = [[DDHAction alloc] initWithName:@"name 1" spoons:1];
  DDHAction *action2 = [[DDHAction alloc] initWithName:@"dummy" spoons:2];
  DDHAction *action3 = [[DDHAction alloc] initWithName:@"name 3" spoons:3];
  [[self dataStoreMock] addAction:action1];
  [[self dataStoreMock] addAction:action2];
  [[self dataStoreMock] addAction:action3];
  [[[self dataStoreMock] day] planAction:action1];
  [[[self dataStoreMock] day] planAction:action2];
  _sut = [[DDHActionStoreViewController alloc] initWithDelegate:[self delegateMock] dataStore:[self dataStoreMock]];
  DDHActionStoreView *actionStoreView = (DDHActionStoreView *)[[self sut] view];

  [[[actionStoreView searchBar] delegate] searchBar:[actionStoreView searchBar] textDidChange:@"name"];

  UICollectionView *collectionView = [actionStoreView collectionView];
  NSInteger numberOfPlannedFilteredItems = [[collectionView dataSource] collectionView:collectionView numberOfItemsInSection:1];
  XCTAssertEqual(numberOfPlannedFilteredItems, 1);
}

- (void)test_didSelectItem_whenActionUnplanned_shouldCallDelegate {
  DDHAction *action1 = [[DDHAction alloc] initWithName:@"name 1" spoons:1];
  [[self dataStoreMock] addAction:action1];
  _sut = [[DDHActionStoreViewController alloc] initWithDelegate:[self delegateMock] dataStore:[self dataStoreMock]];
  DDHActionStoreView *actionStoreView = (DDHActionStoreView *)[[self sut] view];

  UICollectionView *collectionView = [actionStoreView collectionView];
  [[collectionView delegate] collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

  XCTAssertEqualObjects([[[self delegateMock] lastAddedAction] actionId], [action1 actionId]);
}

- (void)test_didSelectItem_whenActionPlanned_shouldNotCallDelegate {
  DDHAction *action1 = [[DDHAction alloc] initWithName:@"name 1" spoons:1];
  [[self dataStoreMock] addAction:action1];
  [[[self dataStoreMock] day] planAction:action1];
  _sut = [[DDHActionStoreViewController alloc] initWithDelegate:[self delegateMock] dataStore:[self dataStoreMock]];
  DDHActionStoreView *actionStoreView = (DDHActionStoreView *)[[self sut] view];

  UICollectionView *collectionView = [actionStoreView collectionView];
  [[collectionView delegate] collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

  XCTAssertNil([[self delegateMock] lastAddedAction]);
}

- (void)test_editAction_shouldCallDelegate {
  DDHAction *action1 = [[DDHAction alloc] initWithName:@"name 1" spoons:1];
  [[self dataStoreMock] addAction:action1];
  [[[self dataStoreMock] day] planAction:action1];
  SEL editAction = NSSelectorFromString(@"contextualEditActionWithAction:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  UIContextualAction *contextualAction = [[self sut] performSelector:editAction withObject:action1];
#pragma clang diagnostic pop

  [contextualAction handler](contextualAction, [[UIView alloc] init], ^(BOOL completed){});

  XCTAssertEqualObjects([[[self delegateMock] lastEditedAction] actionId], [action1 actionId]);
}

- (void)test_deleteAction_shouldCallDelegate {
  DDHAction *action1 = [[DDHAction alloc] initWithName:@"name 1" spoons:1];
  [[self dataStoreMock] addAction:action1];
  [[[self dataStoreMock] day] planAction:action1];
  SEL editAction = NSSelectorFromString(@"contextualDeleteActionWithAction:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  UIContextualAction *contextualAction = [[self sut] performSelector:editAction withObject:action1];
#pragma clang diagnostic pop

  [contextualAction handler](contextualAction, [[UIView alloc] init], ^(BOOL completed){});

  XCTAssertEqual([[[self dataStoreMock] actions] count], 0);
}
@end
