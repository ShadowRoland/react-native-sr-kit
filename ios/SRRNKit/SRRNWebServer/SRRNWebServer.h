//
//  SRRNWebServer.h
//  SRRNKit
//
//  Created by Gary on 2019/2/27.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<React/RCTAssert.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif
#import <React/RCTViewManager.h>
#import <React/RCTView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SRRNWebServerDelegate;

@interface SRRNWebServer : NSObject <RCTBridgeModule>
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, weak) id<SRRNWebServerDelegate> delegate;
+ (instancetype)sharedInstance;
- (void)start;
- (void)stop;
@end

@protocol SRRNWebServerDelegate <NSObject>
- (void)webServerStateChanged:(SRRNWebServer *)webServer;
- (void)webServer:(SRRNWebServer *)webServer received:(NSString *)request;
@end

NS_ASSUME_NONNULL_END
