//
//  NSObject+SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2019/2/28.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SRRNKit)
- (BOOL)srrnHasProperty:(NSString *)name;
- (BOOL)srrnHasMethod:(NSString *)name;
- (id)srrnObjectWithKindOfClass:(Class)aClass;
@end

NS_ASSUME_NONNULL_END
