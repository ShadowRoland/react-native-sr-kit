//
//  SRRNLogger.h
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack/Classes/CocoaLumberjack.h"

NS_ASSUME_NONNULL_BEGIN

static DDLogLevel ddLogLevel = DDLogLevelInfo;

@interface SRRNLogger : NSObject
@property (nonatomic, strong) NSString *directory;
@property (nonatomic, assign) NSTimeInterval rollingFrequency;
@property (nonatomic, assign) NSInteger maxNumber;
@property (nonatomic, assign) long long filesDiskQuota;
//- (void)debug:(NSString *)message;
//- (void)info:(NSString *)message;
//- (void)warn:(NSString *)message;
//- (void)error:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
