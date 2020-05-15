//
//  SRRNLogger.h
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

static DDLogLevel ddLogLevel = DDLogLevelInfo;

@interface SRRNLogger : NSObject<RCTBridgeModule>
@property (nonatomic, strong) NSString *directory;
@property (nonatomic, assign) NSTimeInterval rollingFrequency;
@property (nonatomic, assign) NSInteger maxNumber;
@property (nonatomic, assign) long long filesDiskQuota;
@end

NS_ASSUME_NONNULL_END
