//  Created by Dominik Hauser on 31.05.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "DDHActionInputView.h"

@interface DDHActionInputViewTests : XCTestCase
@property (nonatomic, strong) DDHActionInputView *sut;
@end

@implementation DDHActionInputViewTests

- (void)setUp {
  [self setSut:[[DDHActionInputView alloc] initWithFrame:CGRectZero]];
}

- (void)tearDown {
  [self setSut:nil];
}

- (void)test_shouldHaveTextField {
  UIView *subview = [[self sut] textField];
  XCTAssertTrue([subview isDescendantOfView:[self sut]]);
}

- (void)test_shouldHaveStepperLabel {
  UIView *subview = [[self sut] stepperLabel];
  XCTAssertTrue([subview isDescendantOfView:[self sut]]);
}

- (void)test_shouldHaveStepper {
  UIView *subview = [[self sut] stepper];
  XCTAssertTrue([subview isDescendantOfView:[self sut]]);
}

- (void)test_shouldHaveSaveButton {
  UIView *subview = [[self sut] saveButton];
  XCTAssertTrue([subview isDescendantOfView:[self sut]]);
}
@end
