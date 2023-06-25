//  Created by Dominik Hauser on 02.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

@import RevenueCat;
#import "DDHSettingsViewController.h"
#import "DDHSettingsView.h"
#import "NSUserDefaults+Helper.h"

@interface DDHSettingsViewController ()
@property (nonatomic, strong) id<DDHSettingsViewControllerProtocol> delegate;
@property (nonatomic, strong) RCStoreProduct *product;
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
  [[contentView dailySpoonsStepper] addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
  [[contentView dailySpoonsStepper] setValue:[[NSUserDefaults standardUserDefaults] dailySpoons]];
  [[contentView tipButton] addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
  [contentView update];
  [self setView:contentView];
}

- (DDHSettingsView *)contentView {
  return (DDHSettingsView *)[self view];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setTitle:NSLocalizedString(@"settings.title", nil)];

  UIBarButtonItem *showOnboardingButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"settings.howTo", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showOnboarding:)];
  [[self navigationItem] setLeftBarButtonItem:showOnboardingButton];

  [[RCPurchases sharedPurchases] products:@[
    @"de.dasdom.dailyspoons.small_tip"
  ] completionHandler:^(NSArray<RCStoreProduct *> * _Nonnull products) {
    dispatch_async(dispatch_get_main_queue(), ^{
      RCStoreProduct *product = [products firstObject];
      NSString *buttonTitle = [NSString stringWithFormat:@"%@: %@", [product localizedTitle], [product localizedPriceString]];
      [[[self contentView] tipButton] setTitle:buttonTitle forState:UIControlStateNormal];
      self.product = product;
      [[[self contentView] tipButton] setHidden:NO];
    });
  }];
}

// MARK: - Actions
- (void)stepperValueChanged:(UIStepper *)stepper {
  NSInteger amountOfSpoons = [stepper value];
  [[NSUserDefaults standardUserDefaults] setDailySpoons:amountOfSpoons];
  [[self delegate] dailySpoonsChangedInViewController:self amountOfSpoons:amountOfSpoons];
  [[self contentView] update];
}

- (void)showOnboarding:(UIBarButtonItem *)sender {
  [[self delegate] onboardingDidResetInViewController:self];
}

- (void)purchase:(UIButton *)sender {
  if (self.product) {
    [[RCPurchases sharedPurchases] purchaseProduct:self.product withCompletion:^(RCStoreTransaction * _Nullable transaction, RCCustomerInfo * _Nullable consumerInfo, NSError * _Nullable error, BOOL canceled) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
          if (error.code == RCPurchaseNotAllowedError) {
            [self showAlertWithMessage:NSLocalizedString(@"settings.purchaseNotAllowed", nil)];
          } else if (error.code == RCPurchaseInvalidError) {
            [self showAlertWithMessage:NSLocalizedString(@"settings.purchaseInvalid", nil)];
          }
        } else {
          if (NO == canceled) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"settings.thankYouTitle", nil) message:NSLocalizedString(@"settings.thankYouMessage", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
          }
        }
      });
    }];
  }
}

- (void)showAlertWithMessage:(NSString *)message {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"settings.error", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
  [self presentViewController:alertController animated:YES completion:nil];
}

@end
