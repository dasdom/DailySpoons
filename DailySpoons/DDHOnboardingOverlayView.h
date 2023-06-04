//  Created by Dominik Hauser on 03.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDHOnboardingState) {
  DDHOnboardingStateSpoonBudget,
  DDHOnboardingStateSettings,
  DDHOnboardingStateActions,
  DDHOnboardingStateReload
};

NS_ASSUME_NONNULL_BEGIN

@interface DDHOnboardingOverlayView : UIView
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *nextButton;
- (void)updateFrameWithSuperViewFrame:(CGRect)superViewFrame yPos:(CGFloat)yPos arrowName:(NSString *)arrowName description:(NSString *)description alignment:(UIStackViewAlignment)alignment;
@end

NS_ASSUME_NONNULL_END
