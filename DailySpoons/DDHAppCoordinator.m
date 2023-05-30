//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHAppCoordinator.h"
#import "DDHDayPlannerViewController.h"
#import "DDHActionInputViewController.h"
#import "DDHDataStore.h"
#import "DDHActionStoreViewController.h"
#import "DDHDay.h"
#import "DDHAction.h"

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
  DDHActionStoreViewController *store = [[DDHActionStoreViewController alloc] initWithDelegate:self dataStore:[self dataStore]];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:store];

  UISheetPresentationController *sheet = navigationController.sheetPresentationController;
  sheet.detents = @[UISheetPresentationControllerDetent.mediumDetent, UISheetPresentationControllerDetent.largeDetent];
  sheet.prefersScrollingExpandsWhenScrolledToEdge = YES;
  sheet.prefersEdgeAttachedInCompactHeight = YES;
  sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = YES;

  [viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)addSelectedInViewController:(UIViewController *)viewController name:(NSString *)name {
  DDHActionInputViewController *input = [[DDHActionInputViewController alloc] initWithDelegate:self dataStore:[self dataStore] name:name];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:input];

  UISheetPresentationController *sheet = navigationController.sheetPresentationController;
  sheet.detents = @[UISheetPresentationControllerDetent.mediumDetent, UISheetPresentationControllerDetent.largeDetent];
  sheet.prefersScrollingExpandsWhenScrolledToEdge = YES;
  sheet.prefersEdgeAttachedInCompactHeight = YES;
  sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = YES;

  [viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)editActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action {
  DDHActionInputViewController *input = [[DDHActionInputViewController alloc] initWithDelegate:self dataStore:[self dataStore] editableAction:action];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:input];

  UISheetPresentationController *sheet = navigationController.sheetPresentationController;
  sheet.detents = @[UISheetPresentationControllerDetent.mediumDetent, UISheetPresentationControllerDetent.largeDetent];
  sheet.prefersScrollingExpandsWhenScrolledToEdge = YES;
  sheet.prefersEdgeAttachedInCompactHeight = YES;
  sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = YES;

  [viewController presentViewController:navigationController animated:YES completion:nil];
}

// MARK: - DDHActionInputViewControllerProtocol
- (void)addActionFromViewController:(UIViewController *)viewController action:(DDHAction *)action {
  if ([viewController isKindOfClass:[DDHActionInputViewController class]]) {
    [[self dataStore] addAction:action];
  }
  [[[self dataStore] day] planAction:action];
  [[self dataStore] saveData];

  DDHDayPlannerViewController *dayPlanner = (DDHDayPlannerViewController *)[[self navigationController] topViewController];
  [dayPlanner updateWithDay:[[self dataStore] day]];
  [dayPlanner reload];
  [dayPlanner dismissViewControllerAnimated:true completion:nil];
}

- (void)editDoneInViewController:(UIViewController *)viewController action:(DDHAction *)action {
  DDHDay *day = [[self dataStore] day];
  if ([[day idsOfPlannedActions] containsObject:[action actionId]]) {
    [day updateAction:action];
  }
  [[self dataStore] saveData];
  DDHDayPlannerViewController *dayPlanner = (DDHDayPlannerViewController *)[[self navigationController] topViewController];
  [dayPlanner reload];
  UIViewController *presentedViewController = [(UINavigationController *)[dayPlanner presentedViewController] topViewController];
  if ([presentedViewController respondsToSelector:@selector(reload)]) {
    [presentedViewController performSelector:@selector(reload)];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [viewController dismissViewControllerAnimated:YES completion:nil];
  });
}

@end
