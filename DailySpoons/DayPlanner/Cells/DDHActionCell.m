//  Created by Dominik Hauser on 26.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHActionCell.h"
#import "DDHAction.h"

@interface DDHActionCell ()
@property (nonatomic, strong) UIListContentConfiguration *listContentConfiguration;
@property (nonatomic, strong) UIListContentView *listContentView;
@property (nonatomic, strong) UIStackView *spoonsStackView;
@property (nonatomic, strong) DDHAction *action;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, assign) BOOL isPlanned;
@property (nonatomic, strong) NSLayoutConstraint *leadingSpoonConstraint;
@property (nonatomic, strong) NSLayoutConstraint *trailingSpoonConstraint;
@end

@implementation DDHActionCell
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    _listContentConfiguration = [UIListContentConfiguration cellConfiguration];
    _listContentView = [[UIListContentView alloc] initWithConfiguration:_listContentConfiguration];
    [_listContentView setTranslatesAutoresizingMaskIntoConstraints:NO];

    _spoonsStackView = [[UIStackView alloc] init];
    [_spoonsStackView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.contentView addSubview:_listContentView];
    [self.contentView addSubview:_spoonsStackView];

    _leadingSpoonConstraint = [_spoonsStackView.leadingAnchor constraintEqualToAnchor:_listContentView.trailingAnchor];
    _trailingSpoonConstraint = [_spoonsStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor];

    [NSLayoutConstraint activateConstraints:@[
      [_listContentView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
      [_listContentView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
      [_listContentView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],

//      [[_spoonsStackView topAnchor] constraintEqualToAnchor:[_listContentView topAnchor]],
//      [[_spoonsStackView bottomAnchor] constraintEqualToAnchor:[_listContentView bottomAnchor]],
      [_spoonsStackView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
      _leadingSpoonConstraint,
      _trailingSpoonConstraint
    ]];

    self.tintColor = [UIColor labelColor];
  }
  return self;
}

- (void)updateWithAction:(DDHAction *)action isCompleted:(BOOL)isCompleted {
  [self updateWithAction:action isCompleted:isCompleted isPlanned:NO];
}

- (void)updateWithAction:(DDHAction *)action isCompleted:(BOOL)isCompleted isPlanned:(BOOL)isPlanned {
  [self setAction:action];
  [self setIsCompleted:isCompleted];
  [self setIsPlanned:isPlanned];
  [self setNeedsUpdateConfiguration];
}

- (void)updateConfigurationUsingState:(UICellConfigurationState *)state {
  UIListContentConfiguration *contentConfig = [self.listContentConfiguration updatedConfigurationForState:state];
  [contentConfig setText:self.action.name];
  [contentConfig.textProperties setAlignment:UIListContentTextAlignmentJustified];

  UIListContentConfiguration *valueConfiguration = [[UIListContentConfiguration valueCellConfiguration] updatedConfigurationForState:state];

  [self removeSpoonImageViews];

  [self addSpoonImageViews:self.action.spoons planned:self.isPlanned completed:self.isCompleted valueConfiguration:valueConfiguration];

  if (self.isPlanned || self.isCompleted) {
    [contentConfig.textProperties setColor:[UIColor systemGray3Color]];
  }

  [self.listContentView setConfiguration:contentConfig];

  [self.leadingSpoonConstraint setConstant:valueConfiguration.textToSecondaryTextHorizontalPadding];
  [self.trailingSpoonConstraint setConstant:-contentConfig.directionalLayoutMargins.trailing];

  NSString *typOfAction;
  if (self.isCompleted) {
    typOfAction = NSLocalizedString(@"dayPlanner.spoonsCompleted", nil);
  } else {
    typOfAction = NSLocalizedString(@"dayPlanner.spoonsUncompleted", nil);
  }
  NSString *labelString = [NSString stringWithFormat:@"%@, %ld %@", self.action.name, (long)self.action.spoons, typOfAction];
  [self setAccessibilityLabel:labelString];
  [self setAccessibilityTraits:UIAccessibilityTraitButton];
}

- (void)removeSpoonImageViews {
  NSArray<UIView *> *arrangedViews = [[self spoonsStackView] arrangedSubviews];
  [arrangedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull arrangeSubview, NSUInteger idx, BOOL * _Nonnull stop) {
    [[self spoonsStackView] removeArrangedSubview:arrangeSubview];
    [arrangeSubview removeFromSuperview];
  }];
}

- (void)addSpoonImageViews:(NSInteger)count planned:(BOOL)planned completed:(BOOL)completed valueConfiguration:(UIListContentConfiguration *)valueConfiguration {
  NSInteger normalizedCount = labs(count);
  for (NSInteger i = 0; i < normalizedCount; i++) {
    UIImage *image;
    if (count > 0) {
      if (completed) {
        image = [UIImage systemImageNamed:@"circle.slash"];
      } else {
        image = [UIImage systemImageNamed:@"circle"];
      }
    } else {
      if (completed) {
        image = [UIImage systemImageNamed:@"circle.slash.fill"];
      } else {
        image = [UIImage systemImageNamed:@"circle.fill"];
      }
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    UIColor *color = (planned || completed) ? [UIColor systemGray3Color] : [UIColor labelColor];
    [imageView setTintColor:color];
    [imageView setPreferredSymbolConfiguration:[UIImageSymbolConfiguration configurationWithFont:[[valueConfiguration textProperties] font] scale:UIImageSymbolScaleDefault]];
    [[self spoonsStackView] addArrangedSubview:imageView];
  }

}

@end
