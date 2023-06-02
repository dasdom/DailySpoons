//  Created by Dominik Hauser on 28.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHActionInputViewController.h"
#import "DDHActionInputView.h"
#import "DDHDataStore.h"
#import "DDHAction.h"

@interface DDHActionInputViewController ()
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
  if ([self editableAction]) {
    [[contentView textField] setText:[[self editableAction] name]];
    [[contentView stepper] setValue:[[self editableAction] spoons]];
  } else if ([[self name] length] > 0) {
    [[contentView textField] setText:[self name]];
  }
  [contentView update];
  [self setView:contentView];
}

- (DDHActionInputView *)contentView {
  return (DDHActionInputView *)[self view];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setTitle:NSLocalizedString(@"New action", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[[self contentView] textField] becomeFirstResponder];
}

// MARK: - Actions
- (void)stepperChanged:(UIStepper *)sender {
  [[self contentView] update];
}

- (void)save:(UIButton *)sender {
  NSString *name = [[[self contentView] textField] text];
  NSInteger spoons = (NSInteger)[[[self contentView] stepper] value];
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
