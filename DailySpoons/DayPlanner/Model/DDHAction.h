//  Created by Dominik Hauser on 24.04.23.
//  Copyright © 2023 dasdom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHAction : NSObject
@property (nonatomic, strong) NSUUID *actionId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger spoons;
- (instancetype)initWithName:(NSString *)name spoons:(NSInteger)spoons;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
