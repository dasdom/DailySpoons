//  Created by Dominik Hauser on 23.04.23.
//  
//

@import RevenueCat;
#import "AppDelegate.h"
#import "NSUserDefaults+Helper.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [[NSUserDefaults standardUserDefaults] registerDefaults:@{
    ddh_dailySpoonsKey: [NSNumber numberWithInteger:12]
  }];

  NSString *apiKey = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"RevenueCatKey"];
  if (apiKey) {
    [RCPurchases setLogLevel:RCLogLevelVerbose];
    [RCPurchases configureWithAPIKey:apiKey];
  }

  return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
  // Called when a new scene session is being created.
  // Use this method to select a configuration to create the new scene with.
  return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}
@end
