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

- (void)test_makeScreenshots {
  XCUIApplication *app = [[XCUIApplication alloc] init];
  [app launch];

  XCUIElement *textField = [[[app descendantsMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"Action name"] firstMatch];

  [self onboardingInApp:app language:@"en"];

  [self addActionInApp:app language:@"en"];
  [textField typeText:@"Get up"];
  [[self buttonWithName:@"Save" inApp:app] tap];
  [self tapCellWithName:@"Get up" inApp:app];

  [self addActionInApp:app language:@"en"];
  [textField typeText:@"Breakfast"];
  [[self buttonWithName:@"Save" inApp:app] tap];
  [self tapCellWithName:@"Breakfast" inApp:app];

  [self addActionInApp:app language:@"en"];
  [textField typeText:@"Commute to work"];
  [[self buttonWithName:@"Save" inApp:app] tap];
  [self tapCellWithName:@"Commute to work" inApp:app];

  [self addActionInApp:app language:@"en"];
  [textField typeText:@"Work"];
  [self incrementInApp:app language:@"en"];
  [self incrementInApp:app language:@"en"];
  [self takeScreenshotWithName:@"02_input"];
  [[self buttonWithName:@"Save" inApp:app] tap];

  [self addActionInApp:app language:@"en"];
  [textField typeText:@"Lunch"];
  [[self buttonWithName:@"Save" inApp:app] tap];

  [self addActionInApp:app language:@"en"];
  [textField typeText:@"Commute home"];
  [self incrementInApp:app language:@"en"];
  [[self buttonWithName:@"Save" inApp:app] tap];

  [self addActionInApp:app language:@"en"];
  [textField typeText:@"Prepare dinner"];
  [self incrementInApp:app language:@"en"];
  [[self buttonWithName:@"Save" inApp:app] tap];

  [self takeScreenshotWithName:@"01_dayPlanner"];

  [self swipeCellWithName:@"Commute home" inApp:app];
  [[self buttonWithName:@"Unplan" inApp:app] tap];

  [self swipeCellWithName:@"Prepare dinner" inApp:app];
  [[self buttonWithName:@"Unplan" inApp:app] tap];

  [[self buttonWithName:@"Plan actions" inApp:app] tap];
  [self takeScreenshotWithName:@"03_actionStore"];

  [self tapCellWithName:@"Commute home" inApp:app];

  [[self buttonWithName:@"settings" inApp:app] tap];
  [self takeScreenshotWithName:@"04_settings"];
}

- (void)test_makeScreenshots_de {
  XCUIApplication *app = [[XCUIApplication alloc] init];
  [app launch];

  XCUIElement *textField = [[[app descendantsMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"Aktionsname"] firstMatch];

  [self onboardingInApp:app language:@"de"];

  [self addActionInApp:app language:@"de"];
  [textField typeText:@"Aufstehen"];
  [[self buttonWithName:@"Speichern" inApp:app] tap];
  [self tapCellWithName:@"Aufstehen" inApp:app];

  [self addActionInApp:app language:@"de"];
  [textField typeText:@"Frühstück"];
  [[self buttonWithName:@"Speichern" inApp:app] tap];
  [self tapCellWithName:@"Frühstück" inApp:app];

  [self addActionInApp:app language:@"de"];
  [textField typeText:@"Weg zur Arbeit"];
  [[self buttonWithName:@"Speichern" inApp:app] tap];
  [self tapCellWithName:@"Weg zur Arbeit" inApp:app];

  [self addActionInApp:app language:@"de"];
  [textField typeText:@"Arbeit"];
  [self incrementInApp:app language:@"de"];
  [self incrementInApp:app language:@"de"];
  [self takeScreenshotWithName:@"02_input_de"];
  [[self buttonWithName:@"Speichern" inApp:app] tap];

  [self addActionInApp:app language:@"de"];
  [textField typeText:@"Mittag"];
  [[self buttonWithName:@"Speichern" inApp:app] tap];

  [self addActionInApp:app language:@"de"];
  [textField typeText:@"Weg nach Hause"];
  [self incrementInApp:app language:@"de"];
  [[self buttonWithName:@"Speichern" inApp:app] tap];

  [self addActionInApp:app language:@"de"];
  [textField typeText:@"Abendessen vorbereiten"];
  [self incrementInApp:app language:@"de"];
  [[self buttonWithName:@"Speichern" inApp:app] tap];

  [self takeScreenshotWithName:@"01_tagesPlaner_de"];

  [self swipeCellWithName:@"Weg nach Hause" inApp:app];
  [[self buttonWithName:@"Unplan" inApp:app] tap];

  [self swipeCellWithName:@"Abendessen vorbereiten" inApp:app];
  [[self buttonWithName:@"Unplan" inApp:app] tap];

  [[self buttonWithName:@"Aktionen planen" inApp:app] tap];
  [self takeScreenshotWithName:@"03_actionStore_de"];

  [self tapCellWithName:@"Weg nach Hause" inApp:app];

  [[self buttonWithName:@"Einstellungen" inApp:app] tap];
  [self takeScreenshotWithName:@"04_einstellungen_de"];
}

- (XCUIElement *)buttonWithName:(NSString *)name inApp:(XCUIApplication *)app {
  return [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:name] firstMatch];
}

- (void)addActionInApp:(XCUIApplication *)app language:(NSString *)language {
  if ([language isEqualToString:@"de"]) {
    [[self buttonWithName:@"Aktionen planen" inApp:app] tap];
    [[self buttonWithName:@"hinzufügen" inApp:app] tap];
  } else {
    [[self buttonWithName:@"Plan actions" inApp:app] tap];
    [[self buttonWithName:@"add" inApp:app] tap];
  }
}

- (void)incrementInApp:(XCUIApplication *)app language:(NSString *)language {
  if ([language isEqualToString:@"de"]) {
    [[[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Erhöhen"] firstMatch] tap];
  } else {
    [[[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Increment"] firstMatch] tap];
  }
}

- (void)onboardingInApp:(XCUIApplication *)app language:(NSString *)language {
  if ([language isEqualToString:@"de"]) {
    [[self buttonWithName:@"Nächste" inApp:app] tap];
    [[self buttonWithName:@"Nächste" inApp:app] tap];
    [[self buttonWithName:@"Nächste" inApp:app] tap];
    [[self buttonWithName:@"Fertig" inApp:app] tap];
  } else {
    [[self buttonWithName:@"Next" inApp:app] tap];
    [[self buttonWithName:@"Next" inApp:app] tap];
    [[self buttonWithName:@"Next" inApp:app] tap];
    [[self buttonWithName:@"Done" inApp:app] tap];
  }
}

- (void)tapCellWithName:(NSString *)name inApp:(XCUIApplication *)app {
  [[[[app descendantsMatchingType:XCUIElementTypeStaticText] matchingIdentifier:name] firstMatch] tap];
}

- (void)swipeCellWithName:(NSString *)name inApp:(XCUIApplication *)app {
  [[[[app descendantsMatchingType:XCUIElementTypeStaticText] matchingIdentifier:name] firstMatch] swipeLeft];
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
