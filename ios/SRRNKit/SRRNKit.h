//
//  SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRRNLogger/SRRNLogger.h"

#if __has_include(<React/RCTAssert.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif
#import <React/RCTConvert.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ProcessEnv) {
    ProcessEnvDev = 0,
    ProcessEnvTest,
    ProcessEnvPro,
};

@interface SRRNKit : NSObject<RCTBridgeModule>
+ (instancetype)sharedInstance;
@property (nonatomic, assign) ProcessEnv env;
@property (nonatomic, strong) SRRNLogger *logger;
@end

NS_ASSUME_NONNULL_END
