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
#import <React/RCTViewManager.h>
#import <React/RCTView.h>

typedef NS_ENUM(NSInteger, ProcessEnv) {
    ProcessEnvDev = 0,
    ProcessEnvTest,
    ProcessEnvPro,
};

@interface SRRNKit : NSObject<RCTBridgeModule>
@property (nonatomic, assign) ProcessEnv env;
@property (nonatomic, strong) SRRNLogger *logger;
@end
