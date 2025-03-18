//  Created by Dominik Hauser on 14.03.25.
//  Copyright © 2025 dasdom. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Extension)
- (NSURL *)dayURL;
- (NSURL *)actionsURL;
- (NSURL *)historyURL;
@end

NS_ASSUME_NONNULL_END
