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

- (BOOL)srrnHasProperty:(NSString *)name {
    return name.length == 0 ? NO : class_getProperty(object_getClass(self), name.UTF8String) != NULL;
}

- (BOOL)srrnHasMethod:(NSString *)name {
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

- (id)srrnObjectWithKindOfClass:(Class)aClass {
    id object;
    if ([self isKindOfClass:aClass]) {
        object = self;
    } else if ([self isKindOfClass:NSString.class]) {
        Class ofClass = NSClassFromString((NSString *)self);
        if (ofClass && [ofClass isSubclassOfClass:aClass]) {
            object = [aClass new];
        }
    }

    return object;
}

@end
