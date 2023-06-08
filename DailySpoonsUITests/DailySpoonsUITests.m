//  Created by Dominik Hauser on 08.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <XCTest/XCTest.h>

@interface DailySpoonsUITests : XCTestCase

@end

@implementation DailySpoonsUITests

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)takeScreenshotWithName:(NSString *)name {
  sleep(1);

  XCUIScreenshot *screenshot = [[XCUIScreen mainScreen] screenshot];

  NSString *screenshotName = [NSString stringWithFormat:@"Screenshot-%@-%@.png", [[UIDevice currentDevice] name], name];
  XCTAttachment *attachment = [[XCTAttachment alloc] initWithUniformTypeIdentifier:@"public.png"
                                                                              name:screenshotName
                                                                           payload:[screenshot PNGRepresentation]
                                                                          userInfo:nil];

  [attachment setLifetime:XCTAttachmentLifetimeKeepAlways];

  [self addAttachment:attachment];
}
@end
