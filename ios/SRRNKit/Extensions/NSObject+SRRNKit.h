//
//  NSObject+SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2019/2/28.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SRRNKit)
- (BOOL)hasProperty:(NSString *)name;
- (BOOL)hasMethod:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
