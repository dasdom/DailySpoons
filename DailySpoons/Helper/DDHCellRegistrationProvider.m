//  Created by Dominik Hauser on 29.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import "DDHCellRegistrationProvider.h"
#import "DDHActionCell.h"
#import "DDHSpoonCell.h"
#import "DDHAction.h"
#import "DDHActionState.h"
#import "DDHDataStore.h"
#import "DDHDay.h"

@implementation DDHCellRegistrationProvider
+ (UICollectionViewCellRegistration *)spoonCellRegistration:(DDHDay *)day {
  return [UICollectionViewCellRegistration registrationWithCellClass:[DDHSpoonCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
    DDHSpoonCell *spoonCell = (DDHSpoonCell *)cell;
    NSInteger index = [indexPath item];
    if (index < [day completedSpoons]) {
      [spoonCell updateWithActionState:DDHActionStateCompleted];
    } else if (index < [day plannedSpoons]) {
      [spoonCell updateWithActionState:DDHActionStatePlanned];
    }
  }];
}

+ (UICollectionViewCellRegistration *)actionCellRegistration:(DDHDataStore *)dataStore {
  return [UICollectionViewCellRegistration registrationWithCellClass:[DDHActionCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
    DDHActionCell *actionCell = (DDHActionCell *)cell;
    DDHAction *action = [dataStore actionForId:item];
    DDHActionState actionState = [[dataStore day] actionStateForAction:action];
    [actionCell updateWithAction:action isCompleted:(actionState == DDHActionStateCompleted)];
  }];
}
@end
