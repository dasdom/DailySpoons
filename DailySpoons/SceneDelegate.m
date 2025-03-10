//  Created by Dominik Hauser on 23.04.23.
//  
//

#import "SceneDelegate.h"
#import "DDHAppCoordinator.h"
#import "DDHDayPlannerViewController.h"

@interface SceneDelegate ()
@property (nonatomic, strong) DDHAppCoordinator *appCoordinator;
@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  UIWindowScene *windowScene = (UIWindowScene *)scene;
  _window = [[UIWindow alloc] initWithWindowScene:windowScene];
  _appCoordinator = [[DDHAppCoordinator alloc] init];
  [_appCoordinator start];
  [_window setRootViewController:[_appCoordinator currentViewController]];
  [_window makeKeyAndVisible];
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
  UINavigationController *navigationController = (UINavigationController *)[self.appCoordinator currentViewController];
  DDHDayPlannerViewController *dayPlanner = (DDHDayPlannerViewController *)[navigationController topViewController];
  [dayPlanner resetIfNeeded];
}

@end
