//
//  SRRNUtilities.h
//  SRRNKit
//
//  Created by Gary on 2020/4/23.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface SRRNUtilities : NSObject<RCTBridgeModule>
- (BOOL)isEmptyString:(id)string;
- (id)object:(NSString *)object;
- (void)addObject:(NSString *)object;
@end

NS_ASSUME_NONNULL_END
