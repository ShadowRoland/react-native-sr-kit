//
//  SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "SRRNKit.h"
#import <React/RCTRootView.h>
#import <React/RCTDevMenu.h>

@interface SRRNKit () {
    ProcessEnv _env;
}
- (void)addDevMenuItem:(RCTDevMenu *)menu title:(NSString *)title;
@end

@implementation SRRNKit

RCT_EXPORT_MODULE()

#pragma mark - Singleton

static SRRNKit *sharedInstance;

+ (instancetype)sharedInstance {
    if(!sharedInstance) {
        sharedInstance = [[super allocWithZone:nil] init];  //super 调用allocWithZone
        
        sharedInstance.env = ProcessEnvDev;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            id appDelegate = [UIApplication sharedApplication].delegate;
            UIWindow *window = [appDelegate valueForKey:@"window"];
            if ([window isKindOfClass:UIWindow.class]) {
                RCTRootView *rootView = (RCTRootView *)window.rootViewController.view;
                if ([rootView isKindOfClass:RCTRootView.class]) {
                    [sharedInstance addDevMenuItem:rootView.bridge.devMenu title:@"应用配置"];
                }
            }
        });
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [SRRNKit sharedInstance];
}

- (id)copy {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (ProcessEnv)env {
    return _env;
}

RCT_EXPORT_METHOD(setEnv:(ProcessEnv)env) {
    _env = env;
    ddLogLevel = _env == ProcessEnvPro ? DDLogLevelInfo : DDLogLevelVerbose;
}

- (SRRNLogger *)logger {
    if (!_logger)
        _logger = [SRRNLogger new];
    return _logger;
}

- (SRRNWebServer *)webServer {
    return [SRRNWebServer sharedInstance];
}

- (SRRNUtilities *)utilities {
    if (!_utilities)
        _utilities = [SRRNUtilities new];
    return _utilities;
}

- (void)addDevMenuItem:(RCTDevMenu *)menu title:(NSString *)title {
    if (!menu) {
        return;
    }
    
    [menu addItem:[RCTDevMenuItem buttonItemWithTitle:![Utilities isEmptyString:title] ? title :@"RNKit Debug" handler:^ {
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)RNKitMenuItemClickedNotification
                                                            object:nil
                                                          userInfo:nil];
        
    }]];
}

@end

@implementation RCTConvert (ProcessEnv)
RCT_ENUM_CONVERTER(ProcessEnv,
                   (@{ @"development" : @(ProcessEnvDev),
                       @"test" : @(ProcessEnvTest),
                       @"production" : @(ProcessEnvPro)}),
                   ProcessEnvDev,
                   integerValue)
@end
