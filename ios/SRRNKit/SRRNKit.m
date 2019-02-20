//
//  SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "SRRNKit.h"

@implementation SRRNKit

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(env, NSInteger)

#pragma mark - Singleton

- (void)setEnv:(ProcessEnv)env {
    _env = env;
    ddLogLevel = [SRRNKit sharedInstance].env == ProcessEnvPro ? DDLogLevelInfo : DDLogLevelVerbose;
}

- (SRRNLogger *)logger {
    if (!_logger)
        _logger = [[SRRNLogger alloc] init];
    return _logger;
}

@end
