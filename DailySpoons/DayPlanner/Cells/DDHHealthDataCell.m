//  Created by Dominik Hauser on 10.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHealthDataCell.h"

@interface DDHHealthDataCell ()
@property (nonatomic, strong) UIListContentConfiguration *listContentConfiguration;
@property (nonatomic) NSInteger stepsYesterday;
@property (nonatomic) NSInteger stepsToday;
@end

@implementation DDHHealthDataCell
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _listContentConfiguration = [UIListContentConfiguration cellConfiguration];
  }
  return self;
}

- (void)updateWithStepsYesterday:(NSInteger)stepsYesterday today:(NSInteger)stepsToday {
  [self setStepsYesterday:stepsYesterday];
  [self setStepsToday:stepsToday];
  [self setNeedsUpdateConfiguration];
}

- (void)updateConfigurationUsingState:(UICellConfigurationState *)state {
  UIListContentConfiguration *contentConfig = [self.listContentConfiguration updatedConfigurationForState:state];
  contentConfig.image = [UIImage systemImageNamed:@"figure.walk"];
  [contentConfig setText:[NSString stringWithFormat:NSLocalizedString(@"dayPlanner.steps", nil), self.stepsYesterday, self.stepsToday]];
  [contentConfig.textProperties setAlignment:UIListContentTextAlignmentJustified];

  [self setContentConfiguration:contentConfig];
}
@end
