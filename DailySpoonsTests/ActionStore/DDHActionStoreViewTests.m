//  Created by Dominik Hauser on 31.05.23.
//  Copyright © 2023 dasdom. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "DDHActionStoreView.h"

@interface DDHActionStoreViewTests : XCTestCase
@property (strong, nonatomic) DDHActionStoreView *sut;
@end

@implementation DDHActionStoreViewTests

- (void)setUp {
  UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  [self setSut:[[DDHActionStoreView alloc] initWithFrame:CGRectZero collectionViewLayout:layout]];
}

- (void)tearDown {
  [self setSut:nil];
}

- (void)test_shouldHaveCollectionView {
  UIView *subview = [[self sut] collectionView];
  XCTAssertTrue([subview isDescendantOfView:[self sut]]);
}

- (void)test_shouldHaveSearchBar {
  UIView *subview = [[self sut] searchBar];
  XCTAssertTrue([subview isDescendantOfView:[self sut]]);
}

@end
