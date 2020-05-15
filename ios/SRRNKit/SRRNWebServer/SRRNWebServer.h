//
//  SRRNWebServer.h
//  SRRNKit
//
//  Created by Gary on 2019/2/27.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

typedef NSDictionary * _Nonnull (^SRRNWebServerHTTPProcess)(NSDictionary * _Nullable request);

NS_ASSUME_NONNULL_BEGIN

@protocol SRRNWebServerDelegate;

@interface SRRNWebServer : NSObject <RCTBridgeModule>
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, weak) id<SRRNWebServerDelegate> delegate;
+ (instancetype)sharedInstance;
- (void)start;
- (void)stop;
- (void)addHTTPHandler:(NSString *)method path:(NSString *)path process:(SRRNWebServerHTTPProcess)process;
- (void)removeHTTPHandler:(NSString *)method path:(NSString *)path;
@end

@protocol SRRNWebServerDelegate <NSObject>
- (void)webServerStateChanged:(SRRNWebServer *)webServer;
- (void)webServer:(SRRNWebServer *)webServer received:(NSString *)request;
@end

NS_ASSUME_NONNULL_END
