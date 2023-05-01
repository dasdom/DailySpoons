//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHAppCoordinator.h"
#import "DDHDayPlannerViewController.h"
#import "DDHActionInputViewController.h"
#import "DDHDataStore.h"
#import "DDHActionStoreViewController.h"
#import "DDHDay.h"

@interface DDHAppCoordinator () <DDHDayPlannerViewControllerProtocol, DDHActionStoreViewControllerProtocol, DDHActionInputViewControllerProtocol>
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) DDHDataStore *dataStore;
@end

@implementation DDHAppCoordinator

- (instancetype)init {
  if (self = [super init]) {
    _navigationController = [[UINavigationController alloc] init];
    _dataStore = [[DDHDataStore alloc] init];
  }
  return self;
}

- (void)start {
  DDHDayPlannerViewController *next = [[DDHDayPlannerViewController alloc] initWithDelegate:self dataStore:[self dataStore]];
  [[self navigationController] pushViewController:next animated:NO];
}

- (UIViewController *)currentViewController {
  return [self navigationController];
}

// MARK: - DDHActionStoreViewControllerProtocol/DDHActionInputViewControllerProtocol
- (void)addSelectedInViewController:(UIViewController *)viewController {
  UIViewController *next;
  if ([viewController isKindOfClass:[DDHDayPlannerViewController class]]) {
    DDHActionStoreViewController *store = [[DDHActionStoreViewController alloc] initWithDelegate:self dataStore:[self dataStore]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:store];

    UISheetPresentationController *sheet = navigationController.sheetPresentationController;
    sheet.detents = @[UISheetPresentationControllerDetent.mediumDetent, UISheetPresentationControllerDetent.largeDetent];
    sheet.prefersScrollingExpandsWhenScrolledToEdge = YES;
    sheet.prefersEdgeAttachedInCompactHeight = YES;
    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = YES;

    next = navigationController;
  } else {
    DDHActionInputViewController *input = [[DDHActionInputViewController alloc] initWithDelegate:self dataStore:[self dataStore]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:input];

    UISheetPresentationController *sheet = navigationController.sheetPresentationController;
    sheet.detents = @[UISheetPresentationControllerDetent.mediumDetent, UISheetPresentationControllerDetent.largeDetent];
    sheet.prefersScrollingExpandsWhenScrolledToEdge = YES;
    sheet.prefersEdgeAttachedInCompactHeight = YES;
    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = YES;

    next = navigationController;
  }
  [viewController presentViewController:next animated:YES completion:nil];
}

// MARK: - DDHActionInputViewControllerProtocol
- (void)addActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action {
  if ([viewController isKindOfClass:[DDHActionInputViewController class]]) {
    [[self dataStore] addAction:action];
  }
  [[[self dataStore] day] planAction:action];

  DDHDayPlannerViewController *dayPlanner = (DDHDayPlannerViewController *)[[self navigationController] topViewController];
  [dayPlanner updateWithDay:[[self dataStore] day]];
  [dayPlanner dismissViewControllerAnimated:true completion:nil];
}

@end
