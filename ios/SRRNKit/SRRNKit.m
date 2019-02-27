//
//  SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "SRRNKit.h"

@interface SRRNKit () {
    ProcessEnv _env;
}

@end

@implementation SRRNKit

RCT_EXPORT_MODULE()

#pragma mark - Singleton

static SRRNKit *sharedInstance;

+ (instancetype)sharedInstance {
    if(!sharedInstance) {
        sharedInstance = [[super allocWithZone:nil] init];  //super 调用allocWithZone
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rnKitMenuItemClicked)
                                                     name:@"RNKitMenuItemClicked"
                                                   object:nil];
    }
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _env = ProcessEnvDev;
    }
    return self;
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
        _logger = [[SRRNLogger alloc] init];
    return _logger;
}

- (SRRNWebServer *)webServer {
    return [SRRNWebServer sharedInstance];
}

+ (BOOL)isEmptyString:(id)string {
    if (!string || ![string isKindOfClass:NSString.class]) {
        return YES;
    }
    return [(NSString *)string trim].length == 0;
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
