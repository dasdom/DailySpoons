//  Created by Dominik Hauser on 16.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryEntryCell.h"
#import "DDHHistoryEntry.h"

@interface DDHHistoryEntryCell ()
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *plannedLabel;
@property (nonatomic, strong) UILabel *completedLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UISlider *stateOfMindSlider;
@property (nonatomic, strong) UIStackView *stateOfMindStackView;
@end

@implementation DDHHistoryEntryCell
+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];

    _amountLabel = [[UILabel alloc] init];
    _amountLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

    _plannedLabel = [[UILabel alloc] init];
    _plannedLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

    _completedLabel = [[UILabel alloc] init];
    _completedLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

    UIStackView *textStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_amountLabel, _plannedLabel, _completedLabel]];
    textStackView.axis = UILayoutConstraintAxisVertical;

    _stateOfMindSlider = [[UISlider alloc] init];
    _stateOfMindSlider.minimumValue = -1;
    _stateOfMindSlider.maximumValue = 1;
    _stateOfMindSlider.userInteractionEnabled = NO;
    [_stateOfMindSlider setMinimumValueImage:[UIImage systemImageNamed:@"cloud.rain"]];
    [_stateOfMindSlider setMaximumValueImage:[UIImage systemImageNamed:@"sun.max"]];
    [_stateOfMindSlider setThumbImage:[UIImage systemImageNamed:@"shield.fill"] forState:UIControlStateNormal];

    UILabel *moodKeyLabel = [[UILabel alloc] init];
    moodKeyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    moodKeyLabel.text = NSLocalizedString(@"history.stateOfMind", nil);
    moodKeyLabel.textAlignment = NSTextAlignmentCenter;

    _stateOfMindStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_stateOfMindSlider, moodKeyLabel]];
    _stateOfMindStackView.axis = UILayoutConstraintAxisVertical;
    _stateOfMindStackView.spacing = 5;
    _stateOfMindStackView.hidden = YES;

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_dateLabel, textStackView, _stateOfMindStackView]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.spacing = 20;
    stackView.alignment = UIStackViewAlignmentCenter;

    [self.contentView addSubview:stackView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [_dateLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [NSLayoutConstraint activateConstraints:@[
      [stackView.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor],
      [stackView.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
      [stackView.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor],
      [stackView.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor],
    ]];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.stateOfMindStackView.hidden = YES;
}

- (void)updateWithHistoryEntry:(DDHHistoryEntry *)entry dateFormatter:(NSDateFormatter *)dateFormatter {
  self.dateLabel.text = [dateFormatter stringFromDate:entry.date];

  self.amountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"history.amount", nil), entry.amountOfSpoons];
  self.plannedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"history.planned", nil), entry.plannedSpoons];
  self.completedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"history.completed", nil), entry.completedSpoons];
}

- (void)updateMood:(NSString *)moodClassification valence:(double)valence {
  self.stateOfMindSlider.value = valence;
  self.stateOfMindStackView.hidden = NO;
}
@end
