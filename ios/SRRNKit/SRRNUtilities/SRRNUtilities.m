//
//  SRRNUtilities.m
//  SRRNKit
//
//  Created by Gary on 2020/4/23.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNUtilities.h"
#import <React/UIView+React.h>
#import "SRRNViewController.h"
#import "UIViewController+SRRNKit.h"

@interface SRRNUtilitiesObject : NSObject
@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSString *key;
@end

@implementation SRRNUtilitiesObject
@end

@interface SRRNUtilities ()
@property (nonatomic, strong) NSMutableDictionary *objects;
@end

@implementation SRRNUtilities

RCT_EXPORT_MODULE(RTModule)

#pragma mark - Singleton

static SRRNUtilities * sharedInstance;

+ (instancetype)sharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:nil] init];  //super 调用allocWithZone
        sharedInstance.objects = [NSMutableDictionary dictionary];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [SRRNUtilities sharedInstance];
}

- (id)copy {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Features

- (BOOL)isEmptyString:(id)string {
    if (!string || ![string isKindOfClass:NSString.class]) {
        return YES;
    }
    return [(NSString *)string srrnTrim].length == 0;
}

- (id)object:(NSString *)object {
    if (![self isEmptyString:object]) {
        SRRNUtilitiesObject *obj = _objects[object];
        return obj ? obj.object : nil;
    } else {
        return nil;
    }
}

- (void)removeObject:(NSString *)object {
    [_objects removeObjectForKey:object];
}

RCT_EXPORT_METHOD(object:(NSString *)object
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    id obj = [self object:object];
    if (obj) {
        resolve(obj);
    } else {
        reject(kError(@"can not find object"));
    }
}

RCT_EXPORT_METHOD(addObject:(id)object) {
    if (!object) {
        return;
    }

    SRRNUtilitiesObject *obj = [SRRNUtilitiesObject new];
    obj.object = object;
    obj.key = [NSString stringWithFormat:@"%p", obj.object];
    [obj addObserver:self
          forKeyPath:@"object"
             options:NSKeyValueObservingOptionNew
             context:nil];
    _objects[obj.key] = obj;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([object isKindOfClass:SRRNUtilitiesObject.class]
        && [keyPath isEqualToString:@"object"]) {
        if (![(SRRNUtilitiesObject *)object object]) {
            [self removeObject:[(SRRNUtilitiesObject *)object key]];
        }
    }
}

RCT_EXPORT_METHOD(showViewController:(NSString *)className
                  from:(NSString *)from
                  animated:(BOOL)animated
                  params:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    if ([self isEmptyString:className]) {
        reject(kError(@"class name is empty"));
        return;
    }

    UIViewController *viewController = [self object:from];
    if (![viewController isKindOfClass:UIViewController.class]) {
        reject(kError(@"from is not UIViewController"));
        return;
    }

    UIViewController *vc = [viewController srrnShow:className animated:animated params:params];
    if (!vc) {
        reject(kError(@"showViewController failed"));
    } else {
        resolve(vc);
    }
}

RCT_EXPORT_METHOD(modalViewController:(NSString *)className
                  from:(NSString *)from
                  navigationController:(NSString *)navigationClassName
                  animated:(BOOL)animated
                  params:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    if ([self isEmptyString:className]) {
        reject(kError(@"class name is empty"));
        return;
    }

    UIViewController *viewController = [self object:from];
    if (![viewController isKindOfClass:UIViewController.class]) {
        reject(kError(@"from is not UIViewController"));
        return;
    }

    UIViewController *vc = nil;
    vc = [viewController srrnModal:viewController
              navigationController:navigationClassName
                          animated:animated params:params
                        completion:^{
        resolve(vc);
    }];
    if (!vc) {
        reject(kError(@"modalViewController failed"));
    }
}

RCT_EXPORT_METHOD(pageBack:(NSString *)from) {
    [self pageBack:from animated:YES];
}

RCT_EXPORT_METHOD(pageBack:(NSString *)from animated:(BOOL)animated) {
    UIViewController *viewController = [self object:from];
    if ([viewController isKindOfClass:UIViewController.class]) {
        [viewController srrnPageBack:animated];
    }
}

RCT_EXPORT_METHOD(showProgress:(NSString *)from appearance:(NSDictionary *)appearance) {
    UIViewController *viewController = [self object:from];
    if ([viewController isKindOfClass:UIViewController.class]) {
        [viewController srrnShowProgress:appearance];
    }
}

RCT_EXPORT_METHOD(dismissProgress:(NSString *)from animated:(BOOL)animated) {
    UIViewController *viewController = [self object:from];
    if ([viewController isKindOfClass:UIViewController.class]) {
        [viewController srrnDismissProgress:animated];
    }
}

@end
