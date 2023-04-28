//  Created by Dominik Hauser on 23.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import "DDHDayPlannerViewController.h"
#import "DDHDayPlannerView.h"

@interface DDHDayPlannerViewController ()
@property (nonatomic, strong) UICollectionViewDiffableDataSource *dataSource;
@end

@implementation DDHDayPlannerViewController

- (void)loadView {
  DDHDayPlannerView *contentView = [[DDHDayPlannerView alloc] init];
  UICollectionViewDiffableDataSource *dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:[contentView collectionView] cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
    
  }];
  [self setView: contentView];
}

- (void)viewDidLoad {
  [super viewDidLoad];

}

@end
