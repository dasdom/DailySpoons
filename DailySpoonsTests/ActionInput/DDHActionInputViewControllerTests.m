//  Created by Dominik Hauser on 01.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "DDHActionInputViewController.h"
#import "DDHDataStoreProtocolMock.h"
#import "DDHActionInputViewControllerProtocolMock.h"
#import "DDHActionInputView.h"
#import "DDHAction.h"

@interface DDHActionInputViewControllerTests : XCTestCase
@property (strong, nonatomic) DDHActionInputViewController *sut;
@property (strong, nonatomic) DDHDataStoreProtocolMock *dataStoreMock;
@property (strong, nonatomic) DDHActionInputViewControllerProtocolMock *delegateMock;
@end

@implementation DDHActionInputViewControllerTests

- (void)setUp {
  _dataStoreMock = [[DDHDataStoreProtocolMock alloc] init];
  _delegateMock = [[DDHActionInputViewControllerProtocolMock alloc] init];
  _sut = [[DDHActionInputViewController alloc] initWithDelegate:_delegateMock dataStore:_dataStoreMock];
  [_sut loadViewIfNeeded];
}

- (void)tearDown {
  [self setSut:nil];
  [self setDataStoreMock:nil];
  [self setDelegateMock:nil];
}

- (void)test_view_shouldBeActionInputView {
  XCTAssertEqual([[[self sut] view] class], [DDHActionInputView class]);
}

- (void)test_initWithName_shouldSetNameInTextField {
  _sut = [[DDHActionInputViewController alloc] initWithDelegate:[self delegateMock]
                                                      dataStore:[self dataStoreMock]
                                                           name: @"Bla bla"];

  [[self sut] loadViewIfNeeded];

  DDHActionInputView *actionInputView = (DDHActionInputView *)[[self sut] view];
  XCTAssertEqualObjects([[actionInputView textField] text], @"Bla bla");
}

- (void)test_initWithAction_shouldSetNameInTextField {
  DDHAction *action = [[DDHAction alloc] initWithName:@"Test name" spoons:12];
  _sut = [[DDHActionInputViewController alloc] initWithDelegate:[self delegateMock]
                                                      dataStore:[self dataStoreMock]
                                                 editableAction:action];

  [[self sut] loadViewIfNeeded];

  DDHActionInputView *actionInputView = (DDHActionInputView *)[[self sut] view];
  XCTAssertEqualObjects([[actionInputView textField] text], @"Test name");
}

- (void)test_initWithAction_shouldSetSpoonsInStepper {
  DDHAction *action = [[DDHAction alloc] initWithName:@"Test name" spoons:12];
  _sut = [[DDHActionInputViewController alloc] initWithDelegate:[self delegateMock]
                                                      dataStore:[self dataStoreMock]
                                                 editableAction:action];

  [[self sut] loadViewIfNeeded];

  DDHActionInputView *actionInputView = (DDHActionInputView *)[[self sut] view];
  XCTAssertEqual([[actionInputView stepper] value], 12);
}

- (void)test_appearing_shouldMakeTextFieldFirstResponder {
  UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
  [window setRootViewController:[self sut]];
  [window setHidden:NO];

  [[self sut] beginAppearanceTransition:YES animated:NO];
  [[self sut] endAppearanceTransition];

  DDHActionInputView *actionInputView = (DDHActionInputView *)[[self sut] view];
  XCTAssertTrue([[actionInputView textField] isFirstResponder]);
}

- (void)test_stepperValueChanged_shouldUpdateStepperLabel {
  DDHActionInputView *actionInputView = (DDHActionInputView *)[[self sut] view];

  [[actionInputView stepper] setValue:11];
  [[actionInputView stepper] sendActionsForControlEvents:UIControlEventValueChanged];

  XCTAssertEqualObjects([[actionInputView stepperLabel] text], @"Spoons: 11");
}

- (void)test_save_whenNoActionIsProvided_shouldCallDelegate {
  DDHActionInputView *actionInputView = (DDHActionInputView *)[[self sut] view];
  [[actionInputView textField] setText:@"Test input"];
  [[actionInputView stepper] setValue:7];

  [[actionInputView saveButton] sendActionsForControlEvents:UIControlEventTouchUpInside];

  DDHAction *catchedAction = [[self delegateMock] lastAddedAction];
  XCTAssertEqualObjects([catchedAction name], @"Test input");
  XCTAssertEqual([catchedAction spoons], 7);
}

- (void)test_save_whenActionIsProvided_shouldCallDelegate {
  DDHAction *action = [[DDHAction alloc] initWithName:@"Test name" spoons:12];
  _sut = [[DDHActionInputViewController alloc] initWithDelegate:[self delegateMock]
                                                      dataStore:[self dataStoreMock]
                                                 editableAction:action];
  DDHActionInputView *actionInputView = (DDHActionInputView *)[[self sut] view];
  [[actionInputView stepper] setValue:5];

  [[actionInputView saveButton] sendActionsForControlEvents:UIControlEventTouchUpInside];

  DDHAction *catchedAction = [[self delegateMock] lastEditedAction];
  XCTAssertEqualObjects([catchedAction name], @"Test name");
  XCTAssertEqual([catchedAction spoons], 5);
}

@end
