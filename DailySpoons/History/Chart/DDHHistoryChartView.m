//  Created by Dominik Hauser on 11.04.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryChartView.h"
#import "DDHHistoryEntry.h"

@interface DDHHistoryChartView ()
@property (nonatomic, strong) NSArray<DDHHistoryEntry *> *historyEntries;
@property (nonatomic) NSInteger maxValue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DDHHistoryChartView

- (instancetype)initWithHistoryEntries:(NSArray<DDHHistoryEntry *> *)historyEntires maxValue:(NSInteger)maxValue {
  if (self = [super init]) {
    _historyEntries = historyEntires;
    _maxValue = maxValue;

    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateStyle = NSDateFormatterShortStyle;
    _dateFormatter.timeStyle = NSDateFormatterNoStyle;

    self.backgroundColor = [UIColor systemBackgroundColor];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

  [[UIColor redColor] set];

  CGFloat xOffset = 40;
  CGFloat width = rect.size.width - 2 * xOffset;
  CGFloat height = 0.5 * rect.size.height;
  CGFloat yOffset = 40;

  NSInteger numberOfElements = 15;
  NSInteger spacing = 8;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *now = [NSDate now];
  NSDate *startOfToday = [calendar startOfDayForDate:now];
  NSInteger maxValue = self.maxValue + 1;
  CGFloat dayWidth = width / numberOfElements - spacing;
  CGFloat entryWidth = dayWidth / 2;
  CGFloat y = rect.size.height - yOffset;
  UIFont *font = [UIFont systemFontOfSize:10];
  CGFloat textY = y - 4;


  CGFloat x = [self xForDaysInPast:0 width:width dayWidth:dayWidth spacing:spacing] - entryWidth + xOffset;

  CGFloat moodY = 0.23 * rect.size.height;
  CGFloat moodHeight = 0.1 * rect.size.height;

  // MARK: Axis
  CGRect xAxisRect = CGRectMake(xOffset, y, width, 1);
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:xAxisRect];

  [[UIColor labelColor] set];
  [path fill];

  CGRect yAxisRect = CGRectMake(xOffset, y - height - 40, 1, height + 40);
  path = [UIBezierPath bezierPathWithRect:yAxisRect];

  [[UIColor labelColor] set];
  [path fill];

  // MARK: Legend
  CGRect legendElementRect = CGRectMake(xOffset + 20, y - height - 30, 8, 8);
  path = [UIBezierPath bezierPathWithRect:legendElementRect];

  [[UIColor systemRedColor] set];
  [path stroke];

  NSDictionary<NSAttributedStringKey,id> *attributes = @{
    NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],
    NSForegroundColorAttributeName: [UIColor labelColor]
  };

  NSString *legendText = NSLocalizedString(@"chart.amountOfSpoons", nil);
  CGSize textSize = [legendText sizeWithAttributes:attributes];
  [legendText drawAtPoint:CGPointMake(legendElementRect.origin.x + 20, legendElementRect.origin.y-textSize.height/2+4) withAttributes:attributes];

  legendElementRect = CGRectMake(xOffset + 20, y - height - 15, 8, 8);
  path = [UIBezierPath bezierPathWithRect:legendElementRect];

  [[UIColor systemGreenColor] set];
  [path fill];

  legendText = NSLocalizedString(@"chart.plannedSpoons", nil);
  textSize = [legendText sizeWithAttributes:attributes];
  [legendText drawAtPoint:CGPointMake(legendElementRect.origin.x + 20, legendElementRect.origin.y-textSize.height/2+4) withAttributes:attributes];

  legendElementRect = CGRectMake(xOffset + 20, y - height, 8, 8);
  path = [UIBezierPath bezierPathWithRect:legendElementRect];

  [[UIColor systemBlueColor] set];
  [path fill];

  legendText = NSLocalizedString(@"chart.completedSpoons", nil);
  textSize = [legendText sizeWithAttributes:attributes];
  [legendText drawAtPoint:CGPointMake(legendElementRect.origin.x + 20, legendElementRect.origin.y-textSize.height/2+4) withAttributes:attributes];


  // MARK: Axis labels
  for (NSInteger i = 5; i < self.maxValue; i+=5) {
    NSDictionary<NSAttributedStringKey,id> *attributes = @{
      NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
      NSForegroundColorAttributeName: [UIColor labelColor]
    };

    NSString *labelString = [NSString stringWithFormat:@"%ld", (long)i];
    CGSize stringSize = [labelString sizeWithAttributes:attributes];

    CGFloat yFive =  y = rect.size.height - (height * i / maxValue) - yOffset;
    [labelString drawAtPoint:CGPointMake(xOffset - stringSize.width - 4, yFive) withAttributes:attributes];
  }

  // MARK: Today label
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  CGContextTranslateCTM(context, x-font.pointSize, textY);
  CGContextRotateCTM(context, -M_PI_2);

  NSString *todayString = NSLocalizedString(@"chart.today", nil);
  [todayString drawAtPoint:CGPointMake(0, 0) withAttributes:
   @{
    NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
    NSForegroundColorAttributeName: [UIColor labelColor]
  }];

  CGContextRestoreGState(context);


  // MARK: StateOfMind
  CGRect goodMoodRect = CGRectMake(xOffset, moodY - moodHeight - 10, width, moodHeight + 10);
  path = [UIBezierPath bezierPathWithRect:goodMoodRect];

  [[[UIColor systemGreenColor] colorWithAlphaComponent:0.4] set];
  [path fill];

  CGRect badMoodRect = CGRectMake(xOffset, moodY, width, moodHeight + 10);
  path = [UIBezierPath bezierPathWithRect:badMoodRect];

  [[[UIColor systemRedColor] colorWithAlphaComponent:0.4] set];
  [path fill];

  NSString *stateOfMindTitle = NSLocalizedString(@"chart.stateOfMind.title", nil);
  attributes = @{
    NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
    NSForegroundColorAttributeName: [UIColor labelColor]
  };
  textSize = [stateOfMindTitle sizeWithAttributes:attributes];

  [stateOfMindTitle drawAtPoint:CGPointMake(xOffset + (width- textSize.width)/2, moodY - moodHeight - 14 - textSize.height) withAttributes:attributes];

  legendText =  NSLocalizedString(@"chart.stateOfMind.veryPleasant", nil);
  attributes = @{
    NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],
    NSForegroundColorAttributeName: [UIColor secondaryLabelColor]
  };
  [legendText drawAtPoint:CGPointMake(xOffset + 4, moodY - moodHeight - 10) withAttributes:attributes];

  legendText =  NSLocalizedString(@"chart.stateOfMind.veryUnpleasant", nil);
  textSize = [stateOfMindTitle sizeWithAttributes:attributes];
  [legendText drawAtPoint:CGPointMake(xOffset + 4, moodY + moodHeight + 10 - textSize.height) withAttributes:attributes];


  // MARK: History entries
  for (DDHHistoryEntry *entry in self.historyEntries) {

    NSDate *startOfEntryDate = [calendar startOfDayForDate:entry.date];

    NSInteger numberOfDays = [calendar components:NSCalendarUnitDay fromDate:startOfEntryDate toDate:startOfToday options:0].day;

    if (numberOfDays >= numberOfElements) {
      break;
    }

    CGFloat x = [self xForDaysInPast:numberOfDays width:width dayWidth:dayWidth spacing:spacing] - entryWidth + xOffset;

    // Completed spoons
    CGFloat barHeight = height * entry.completedSpoons / maxValue;
    CGFloat y = rect.size.height - barHeight - yOffset;

    CGRect bar = CGRectMake(x, y, entryWidth, barHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bar];

    [[UIColor systemBlueColor] set];
    [path fill];

    // Planned spoons
    barHeight = height * entry.plannedSpoons / maxValue;
    y = rect.size.height - barHeight - yOffset;

    bar = CGRectMake(x - entryWidth, y, entryWidth, barHeight);
    path = [UIBezierPath bezierPathWithRect:bar];

    [[UIColor systemGreenColor] set];
    [path fill];

    // Amount of spoons
    barHeight = height * entry.amountOfSpoons / maxValue;
    y = rect.size.height - barHeight - yOffset;

    bar = CGRectMake(x - entryWidth, y, dayWidth, barHeight);
    path = [UIBezierPath bezierPathWithRect:bar];

    [[UIColor systemRedColor] set];
    [path stroke];

    NSString *dayString = [self.dateFormatter stringFromDate:entry.date];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    UIFont *dayFont = [UIFont monospacedSystemFontOfSize:13 weight:UIFontWeightMedium];

    NSDictionary<NSAttributedStringKey,id> *attributes = @{
      NSFontAttributeName: dayFont,
      NSForegroundColorAttributeName: [UIColor labelColor],
      NSBackgroundColorAttributeName: [[UIColor systemBackgroundColor] colorWithAlphaComponent:0.6]
    };

    CGSize dayStringSize = [dayString sizeWithAttributes:attributes];

    CGContextTranslateCTM(context, x+entryWidth-dayWidth+(dayWidth-dayStringSize.height)/2, textY);
    CGContextRotateCTM(context, -M_PI_2);

    [dayString drawAtPoint:CGPointMake(0, 0) withAttributes:attributes];

    CGContextRestoreGState(context);

    if (entry.mood > -10) {
      CGRect markerRect = CGRectMake(x+entryWidth-dayWidth+(dayWidth-10)/2, moodY - entry.mood * moodHeight - 5, 10, 10);
      path = [UIBezierPath bezierPathWithOvalInRect:markerRect];

      [[UIColor labelColor] set];
      path.lineWidth = 2;
      [path stroke];
    }
  }
}

- (CGFloat)xForDaysInPast:(NSInteger)daysInPast width:(CGFloat)width dayWidth:(CGFloat)dayWidth spacing:(CGFloat)spacing {
  return width - daysInPast * (dayWidth + spacing);
}

@end
