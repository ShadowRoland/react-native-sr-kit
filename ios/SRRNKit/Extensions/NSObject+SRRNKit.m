//
//  NSObject+SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2019/2/28.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "NSObject+SRRNKit.h"
#import "objc/runtime.h"

@implementation NSObject (SRRNKit)

- (BOOL)hasProperty:(NSString *)name {
    return name.length == 0 ? NO : class_getProperty(object_getClass(self), name.UTF8String) != NULL;
}

- (BOOL)hasMethod:(NSString *)name {
    if (name.length == 0)
        return NO;
    
    u_int count;
    Method *methods = class_copyMethodList(object_getClass(self), &count);
    for (int i = 0; i < count; i++) {
        NSString *methodName =
        [NSString stringWithCString:sel_getName(method_getName(methods[i]))
                                               encoding:NSUTF8StringEncoding];
        if ([name isEqualToString:methodName]) {
            free(methods);
            return YES;
        }
    }
    free(methods);
    return NO;
}
@end
