//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHSettingsViewController.h"
#import "DDHSettingsView.h"
#import "NSUserDefaults+Helper.h"

@interface DDHSettingsViewController ()
@property (nonatomic, strong) id<DDHSettingsViewControllerProtocol> delegate;
@end

@implementation DDHSettingsViewController

- (instancetype)initWithDelegate:(id<DDHSettingsViewControllerProtocol>)delegate {
  if (self = [super init]) {
    _delegate = delegate;
  }
  return self;
}

- (void)loadView {
  DDHSettingsView *contentView = [[DDHSettingsView alloc] init];
  [[contentView stepper] addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
  [[contentView stepper] setValue:[[NSUserDefaults standardUserDefaults] dailySpoons]];
  [contentView update];
  [self setView:contentView];
}

- (DDHSettingsView *)contentView {
  return (DDHSettingsView *)[self view];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setTitle:@"Settings"];
}

// MARK: - Actions
- (void)stepperValueChanged:(UIStepper *)stepper {
  NSInteger amountOfSpoons = [stepper value];
  [[NSUserDefaults standardUserDefaults] setDailySpoons:amountOfSpoons];
  [[self delegate] dailySpoonsChangedInViewController:self amountOfSpoons:amountOfSpoons];
  [[self contentView] update];
}
@end
