//  Created by Dominik Hauser on 11.04.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHHistoryEntry;

@interface DDHHistoryChartView : UIView
- (instancetype)initWithHistoryEntries:(NSArray<DDHHistoryEntry *> *)historyEntires maxValue:(NSInteger)maxValue;
@end

NS_ASSUME_NONNULL_END
