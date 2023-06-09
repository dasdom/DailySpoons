//  Created by Dominik Hauser on 09.06.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const UICONFIGURATIONSTATECUSTOMKEY_ACTION;
extern NSString * const UICONFIGURATIONSTATECUSTOMKEY_IS_COMPLETED;
extern NSString * const UICONFIGURATIONSTATECUSTOMKEY_IS_PLANNED;

@class DDHAction;

@interface UICellConfigurationState (ActionCellAdditions)
- (DDHAction *)action;
- (void)setAction:(DDHAction *)action;
- (BOOL)isCompleted;
- (void)setIsCompleted:(BOOL)isCompleted;
- (BOOL)isPlanned;
- (void)setIsPlanned:(BOOL)isPlanned;
@end

NS_ASSUME_NONNULL_END
