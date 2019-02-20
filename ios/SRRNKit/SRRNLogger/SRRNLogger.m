//
//  SRRNLogger.m
//  SRRNKit
//
//  Created by Gary on 2019/2/19.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "SRRNLogger.h"

@interface SRRNLogger () {
    NSString *_directory;
}
@property (nonatomic, strong) DDFileLogger *logger;
@end

@implementation SRRNLogger

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(directory, NSString)
RCT_EXPORT_VIEW_PROPERTY(rollingFrequency, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(maxNumber, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(filesDiskQuota, NSInteger)

- (NSString *)directory {
    if (_directory.length > 0) {
        NSString *document =
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        return [document stringByAppendingPathComponent:_directory];
    }
    return _logger ? _logger.logFileManager.logsDirectory : nil;
}

- (void)setDirectory:(NSString *)directory {
    if (![_directory isEqualToString:directory]) {
        [self reinitLogger];
    }
}

- (void)setRollingFrequency:(NSTimeInterval)rollingFrequency {
    if (_rollingFrequency != rollingFrequency) {
        _rollingFrequency = rollingFrequency;
        [self reinitLogger];
    }
}

- (void)setMaxNumber:(NSInteger)maxNumber {
    if (_maxNumber != maxNumber) {
        _maxNumber = maxNumber;
        [self reinitLogger];
    }
}

- (void)setFilesDiskQuota:(long long)filesDiskQuota {
    if (_filesDiskQuota != filesDiskQuota) {
        _filesDiskQuota = filesDiskQuota;
        [self reinitLogger];
    }
}

- (DDFileLogger *)logger {
    [self initLogger];
    return _logger;
}

- (void)initLogger {
    if (!_logger) {
        [DDTTYLogger sharedInstance].colorsEnabled = YES;
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [self reinitLogger];
    }
}

- (void)reinitLogger {
    [DDLog removeLogger:_logger];
    if (_directory.length > 0) {
        _logger =
        [[DDFileLogger alloc] initWithLogFileManager:[[DDLogFileManagerDefault alloc]
                                                      initWithLogsDirectory:self.directory]];
    } else {
        _logger = [[DDFileLogger alloc] init];
    }
    _logger.rollingFrequency = _rollingFrequency > 0 ? _rollingFrequency : 60 * 60 * 24; //24 hour rolling
    _logger.logFileManager.maximumNumberOfLogFiles = _maxNumber > 0 ? _maxNumber : 10;
    _logger.logFileManager.logFilesDiskQuota =
    _filesDiskQuota > 0 ? _filesDiskQuota : 20 * 1024 * 1024;
    [DDLog addLogger:_logger];
}

RCT_EXPORT_METHOD(debug:(NSString *)message) {
    if (!message || message.length == 0)
        return;
    
    [self initLogger];
    DDLogDebug(message, nil);
}

RCT_EXPORT_METHOD(info:(NSString *)message) {
    if (!message || message.length == 0)
        return;
    
    [self initLogger];
    DDLogInfo(message, nil);
}

RCT_EXPORT_METHOD(warn:(NSString *)message) {
    if (!message || message.length == 0)
        return;
    
    [self initLogger];
    DDLogWarn(message, nil);
}

RCT_EXPORT_METHOD(error:(NSString *)message) {
    if (!message || message.length == 0)
        return;
    
    [self initLogger];
    DDLogError(message, nil);
}

@end
