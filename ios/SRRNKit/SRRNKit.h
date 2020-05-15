//
//  SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "SRRNLogger.h"
#import "SRRNWebServer.h"
#import "SRRNUtilities.h"

#define LogDebug        DDLogDebug
#define LogInfo         DDLogInfo
#define LogWarn         DDLogWarn
#define LogError        DDLogError
#define LogFunc         LogInfo(@"%s", __func__)
#define LogDebugFunc    LogDebug(@"%s", __func__)

#define Utilities       [SRRNKit sharedInstance].utilities

NS_ASSUME_NONNULL_BEGIN

static const NSString *RNKitMenuItemClickedNotification = @"RNKitMenuItemClickedNotification";

typedef NS_ENUM(NSInteger, ProcessEnv) {
    ProcessEnvDev = 0,
    ProcessEnvTest,
    ProcessEnvPro,
};

@interface SRRNKit : NSObject<RCTBridgeModule>
@property (nonatomic, assign) ProcessEnv env;
//@property (nonatomic, strong) RCTBridge *bridge;
@property (nonatomic, strong) SRRNLogger *logger;
@property (nonatomic, strong) SRRNWebServer *webServer;
@property (nonatomic, strong) SRRNUtilities *utilities;
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
