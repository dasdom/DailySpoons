//  Created by Dominik Hauser on 16.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

@class DDHHistoryEntry;

NS_ASSUME_NONNULL_BEGIN

@interface DDHHistoryEntryCell : UITableViewCell
+ (NSString *)identifier;
- (void)updateWithHistoryEntry:(DDHHistoryEntry *)entry dateFormatter:(NSDateFormatter *)dateFormatter;
- (void)updateMood:(NSString *)moodClassification valence:(double)valence;
@end

NS_ASSUME_NONNULL_END
