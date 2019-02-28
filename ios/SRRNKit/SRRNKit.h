//
//  SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Extensions/Extensions.h"
#import "SRRNLogger/SRRNLogger.h"
#import "SRRNWebServer/SRRNWebServer.h"

#if __has_include(<React/RCTAssert.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif
#import <React/RCTConvert.h>
#import <React/RCTView.h>

#define LogDebug        DDLogDebug
#define LogInfo         DDLogInfo
#define LogWarn         DDLogWarn
#define LogError        DDLogError
#define LogFunc         LogInfo(@"%s", __func__)
#define LogDebugFunc    LogDebug(@"%s", __func__)

NS_ASSUME_NONNULL_BEGIN

static const NSString *RNKitMenuItemClickedNotification = @"RNKitMenuItemClickedNotification";

typedef NS_ENUM(NSInteger, ProcessEnv) {
    ProcessEnvDev = 0,
    ProcessEnvTest,
    ProcessEnvPro,
};

@interface SRRNKit : NSObject<RCTBridgeModule>
@property (nonatomic, assign) ProcessEnv env;
@property (nonatomic, strong) SRRNLogger *logger;
@property (nonatomic, strong) SRRNWebServer *webServer;
+ (instancetype)sharedInstance;
+ (BOOL)isEmptyString:(id)string;
@end

NS_ASSUME_NONNULL_END
