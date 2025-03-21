//  Created by Dominik Hauser on 14.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "NSFileManager+Extension.h"

@implementation NSFileManager (Extension)
- (NSURL *)dayURL {
  NSURL *sharedURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.de.dasdom.dailyspoons"];
  NSURL *url = [sharedURL URLByAppendingPathComponent:@"day.json"];
  return url;
}

- (NSURL *)documentsURL {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

- (NSURL *)actionsURL {
  NSURL *url = [[self documentsURL] URLByAppendingPathComponent:@"actions.json"];
  return url;
}

- (NSURL *)historyURL {
  NSURL *url = [[self documentsURL] URLByAppendingPathComponent:@"history.sq"];
  return url;
}

- (NSURL *)csvExportURLForDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy_MM_dd";
  NSString *fileName = [NSString stringWithFormat:@"daily_spoons_%@.csv", [dateFormatter stringFromDate:date]];
  NSURL *url = [[self documentsURL] URLByAppendingPathComponent:fileName];
  return url;
}
@end
