//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHActionInputViewController.h"
#import "DDHActionInputView.h"
#import "DDHDataStore.h"
#import "DDHAction.h"

@interface DDHActionInputViewController () <UITextFieldDelegate>
@property (nonatomic, weak) id<DDHActionInputViewControllerProtocol> delegate;
@property (nonatomic, strong) id<DDHDataStoreProtocol> dataStore;
@property (nonatomic, strong) DDHAction *editableAction;
@property (nonatomic, strong) NSString *name;
@end

@implementation DDHActionInputViewController
- (instancetype)initWithDelegate:(id<DDHActionInputViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore {
  return [self initWithDelegate:delegate dataStore:dataStore editableAction:nil];
}

- (instancetype)initWithDelegate:(id<DDHActionInputViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore name:(NSString *)name {
  if (self = [self initWithDelegate:delegate dataStore:dataStore editableAction:nil]) {
    _name = name;
  }
  return self;
}

- (instancetype)initWithDelegate:(id<DDHActionInputViewControllerProtocol>)delegate dataStore:(id<DDHDataStoreProtocol>)dataStore editableAction:(DDHAction *)editableAction {
  if (self = [super init]) {
    _delegate = delegate;
    _dataStore = dataStore;
    _editableAction = editableAction;
  }
  return self;
}

- (void)loadView {
  DDHActionInputView *contentView = [[DDHActionInputView alloc] init];
  [[contentView stepper] addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
  [[contentView saveButton] addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
  [[contentView textField] setDelegate:self];
  if ([self editableAction]) {
    [[contentView textField] setText:[[self editableAction] name]];
    [[contentView stepper] setValue:[[self editableAction] spoons]];
  } else if ([[self name] length] > 0) {
    [[contentView textField] setText:[self name]];
  }
  if ([[[contentView textField] text] length] > 0) {
    [[contentView saveButton] setEnabled:YES];
  }
  [contentView update];
  [self setView:contentView];
}

- (DDHActionInputView *)contentView {
  return (DDHActionInputView *)[self view];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setTitle:NSLocalizedString(@"actionInput.title", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[[self contentView] textField] becomeFirstResponder];
}

// MARK: UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

  NSString *newText = [[textField text] stringByReplacingCharactersInRange:range withString:string];

  if ([newText length] > 0) {
    [[[self contentView] saveButton] setEnabled:YES];
  } else {
    [[[self contentView] saveButton] setEnabled:NO];
  }

  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

// MARK: - Actions
- (void)stepperChanged:(UIStepper *)sender {
  [[self contentView] update];
}

- (void)save:(UIButton *)sender {
  NSString *name = [[[self contentView] textField] text];
  NSInteger spoons = (NSInteger)[[[self contentView] stepper] value];
  if ([[[self contentView] typeSegmentedControl] selectedSegmentIndex] == 1) {
    spoons = -spoons;
  }
  DDHAction *action;
  if ([self editableAction]) {
    action = [self editableAction];
    [action setName:name];
    [action setSpoons:spoons];
    [[self delegate] editDoneInViewController:self action:action];
  } else {
    action = [[DDHAction alloc] initWithName:name spoons:spoons];
    [[self delegate] addActionFromViewController:self action:action];
  }
}

@end
