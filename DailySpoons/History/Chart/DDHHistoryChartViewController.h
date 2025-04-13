//  Created by Dominik Hauser on 11.04.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHHistoryEntry;

@protocol DDHHistoryChartViewControllerProtocol <NSObject>

@end

@interface DDHHistoryChartViewController : UIViewController
- (instancetype)initWithHistoryEntries:(NSArray<DDHHistoryEntry *> *)historyEntires;
@end

NS_ASSUME_NONNULL_END
