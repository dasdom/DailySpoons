//  Created by Dominik Hauser on 16.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import "DDHHistoryListDiffableDataSource.h"

@implementation DDHHistoryListDiffableDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [self sectionIdentifierForIndex:section];
}
@end
