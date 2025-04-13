//  Created by Dominik Hauser on 16.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHHistoryEntry;

@protocol DDHHistoryListViewControllerProtocol <NSObject>
- (void)didSelectChart:(UIViewController *)viewController entries:(NSArray<DDHHistoryEntry *> *)entries;
@end

@interface DDHHistoryListViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHHistoryListViewControllerProtocol>)delegate;
@end

NS_ASSUME_NONNULL_END
