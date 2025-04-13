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

  CGFloat xOffset = 20;
  CGFloat width = rect.size.width - 2 * xOffset;
  CGFloat height = 0.6 * rect.size.height;
  CGFloat yOffset = 100;

  NSInteger numberOfElements = 15;
  NSInteger spacing = 8;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *now = [NSDate now];
  NSInteger maxValue = self.maxValue + 1;
  CGFloat dayWidth = width / numberOfElements - spacing;
  CGFloat entryWidth = dayWidth / 2;

  NSString *todayString = NSLocalizedString(@"chart.today", nil);

  CGFloat x = [self xForDaysInPast:0 width:width dayWidth:dayWidth spacing:spacing] - entryWidth + xOffset;
  CGFloat y = rect.size.height - yOffset;
  UIFont *font = [UIFont systemFontOfSize:10];

  CGFloat moodY = 0.17 * rect.size.height;
  CGFloat moodHeight = 0.1 * rect.size.height;

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  CGContextTranslateCTM(context, x-font.pointSize, y);
  CGContextRotateCTM(context, -M_PI_2);

  [todayString drawAtPoint:CGPointMake(0, 0) withAttributes:
   @{
    NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
    NSForegroundColorAttributeName: [UIColor labelColor]
  }];

  CGContextRestoreGState(context);

  CGRect goodMoodRect = CGRectMake(xOffset, moodY - moodHeight - 10, width, moodHeight + 10);
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:goodMoodRect];

  [[[UIColor systemGreenColor] colorWithAlphaComponent:0.4] set];
  [path fill];

  CGRect badMoodRect = CGRectMake(xOffset, moodY, width, moodHeight + 10);
  path = [UIBezierPath bezierPathWithRect:badMoodRect];

  [[[UIColor systemRedColor] colorWithAlphaComponent:0.4] set];
  [path fill];

  for (DDHHistoryEntry *entry in self.historyEntries) {

    NSInteger numberOfDays = [calendar components:NSCalendarUnitDay fromDate:entry.date toDate:now options:0].day;

    CGFloat x = [self xForDaysInPast:numberOfDays width:width dayWidth:dayWidth spacing:spacing] - entryWidth + xOffset;
    CGFloat textY = y - 4;

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

    bar = CGRectMake(x - entryWidth, y, dayWidth, 2);
    path = [UIBezierPath bezierPathWithRect:bar];

    [[UIColor labelColor] set];
    [path fill];

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

    CGContextTranslateCTM(context, x+entryWidth-dayWidth+fabs(dayStringSize.height-dayWidth)/2, textY);
    CGContextRotateCTM(context, -M_PI_2);

    [dayString drawAtPoint:CGPointMake(0, 0) withAttributes:attributes];

    CGContextRestoreGState(context);

    if (entry.mood > -10) {
      CGRect markerRect = CGRectMake(x+entryWidth-dayWidth+fabs(10-dayWidth)/2, moodY + entry.mood * moodHeight, 10, 10);
      path = [UIBezierPath bezierPathWithOvalInRect:markerRect];

      [[UIColor labelColor] set];
      path.lineWidth = 2;
      [path stroke];
    }

    if (numberOfDays >= numberOfElements - 1) {
      break;
    }
  }
}

- (CGFloat)xForDaysInPast:(NSInteger)daysInPast width:(CGFloat)width dayWidth:(CGFloat)dayWidth spacing:(CGFloat)spacing {
  return width - daysInPast * (dayWidth + spacing);
}

@end
