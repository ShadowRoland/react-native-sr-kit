//
//  SRRNWebServer.m
//  SRRNKit
//
//  Created by Gary on 2019/2/27.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "SRRNWebServer.h"
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerResponse.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerURLEncodedFormRequest.h>
#import "SRRNKit.h"

@interface SRRNWebServerHTTPHandler : NSObject
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, copy) SRRNWebServerHTTPProcess process;
@end

@implementation SRRNWebServerHTTPHandler
@end

static const NSString *kHtmlBaseFormat = @"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head><body>%@</body></html>";

@interface SRRNWebServer ()

@property (nonatomic, strong) GCDWebServer *webServer;
@property (nonatomic, strong) NSMutableDictionary *httpHandlers;
@end

@implementation SRRNWebServer

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(isRunning, BOOL)
RCT_EXPORT_VIEW_PROPERTY(port, NSInteger)

#pragma mark - Singleton

static SRRNWebServer *sharedInstance;

+ (instancetype)sharedInstance {
    if(!sharedInstance) {
        sharedInstance = [[super allocWithZone:nil] init];  //super 调用allocWithZone
    }
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.port = 9999;
        self.httpHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [SRRNWebServer sharedInstance];
}

- (id)copy {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark -

- (BOOL)isRunning {
    return _webServer && _webServer.isRunning;
}

- (void)setIsRunning:(BOOL)isRunning {
    
}

- (void)setPort:(NSInteger)port {
    if (_port != port) {
        _port = port;
        if (self.isRunning) {
            [self stop];
            [self start];
        }
    }
}

RCT_EXPORT_METHOD(start) {
    if (!self.webServer.isRunning) {
        [self.webServer startWithPort:_port bonjourName:@"SRRNWebServer"];
        if ([_delegate respondsToSelector:@selector(webServerStateChanged:)]) {
            [_delegate webServerStateChanged:self];
        }
    }
}

RCT_EXPORT_METHOD(stop) {
    if (self.webServer.isRunning) {
        [self.webServer stop];
        if ([_delegate respondsToSelector:@selector(webServerStateChanged:)]) {
            [_delegate webServerStateChanged:self];
        }
    }
}

- (void)addHTTPHandler:(NSString *)method path:(NSString *)path process:(SRRNWebServerHTTPProcess)process {
    NSString *trimPath = [self trimPath:path];
    NSString *upperMethod = [[method srrnTrim] uppercaseString];
    if (trimPath.length == 0 || upperMethod.length == 0 || !process) {
        return;
    }
    
    SRRNWebServerHTTPHandler *handler = [SRRNWebServerHTTPHandler new];
    handler.method = method;
    handler.path = path;
    handler.process = process;
    self.httpHandlers[[self httpHandlerKey:method path:path]] = handler;
}

- (void)removeHTTPHandler:(NSString *)method path:(NSString *)path {
    NSString *trimPath = [self trimPath:path];
    NSString *upperMethod = [[method srrnTrim] uppercaseString];
    if (!(trimPath.length == 0 || upperMethod.length == 0)) {
        [self.httpHandlers removeObjectForKey:[self httpHandlerKey:method path:path]];
    }
}

- (NSString *)httpHandlerKey:(NSString *)method path:(NSString *)path {
    return [NSString stringWithFormat:@"method:%@,path:%@", method, path];
}

- (GCDWebServer *)webServer {
    if (_webServer) {
        return _webServer;
    }
    
    __weak typeof(self) weakSelf = self;
    _webServer = [GCDWebServer new];
    [_webServer addDefaultHandlerForMethod:@"GET"
                              requestClass:[GCDWebServerURLEncodedFormRequest class]
                              processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request)
     {
         if (!weakSelf) {
             return nil;
         }
         
         NSDictionary *query = request.query;
         NSString *path = [weakSelf trimPath:request.URL.path];
         NSString *body;
         if ([Utilities isEmptyString:path]) {
             if (query.count == 0) { //默认访问手机的日志文件列表
                 body = [self logFiles];
             } else if (request.query[@"index"]) {
                 if (request.query[@"length"]) {
                     body = [self logFileContent:[request.query[@"index"] integerValue]
                                          length:[request.query[@"length"] integerValue]];
                 } else {
                     body = [self logFileContent:[request.query[@"index"] integerValue] length:-1];
                 }
                 return [GCDWebServerDataResponse responseWithText:body];
             }
             NSString *html =
             [NSString stringWithFormat:(NSString *)kHtmlBaseFormat, body];
             return [GCDWebServerDataResponse responseWithHTML:html];
         } else {
//             SRRNWebServerHTTPHandler *handler = weakSelf.httpHandlers[[weakSelf httpHandlerKey:@"GET" path:path]];
//             if (handler) {
//                 return [GCDWebServerDataResponse responseWithText:@""];
//             }
             return [GCDWebServerDataResponse responseWithText:@""];
         }
    }];
    return _webServer;
}

- (NSString *)trimPath:(NSString *)path {
    return [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]];
}

//MARK: Log Reader

- (NSString *)logFiles {
    NSString *request = @"接收请求：获取所有的日志文件列表";
    LogInfo(request, nil);
    if ([_delegate respondsToSelector:@selector(webServer:received:)]) {
        [_delegate webServer:self received:request];
    }
    
    NSMutableString *body = [NSMutableString string];
    NSString *logDirectory = [SRRNKit sharedInstance].logger.directory;
    NSError *error;
    NSArray *files =
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logDirectory error:&error];
    if (error) {
        [body appendFormat:@"<h2>获取日志文件列表失败</h2><p>%@</p>", error.localizedDescription];
        return body;
    }
    
    if (files.count == 0) {
        [body appendString:@"<h2>日志文件列表为空</h2>"];
        return body;
    }
    
    [body appendString:@"<h2>日志文件列表</h2>"];
    [body appendString:@"<ul>"];
    
    //按照修改时间排序
    files = [files sortedArrayUsingComparator:^NSComparisonResult(id object1, id object2) {
        NSDictionary* attributes1  =
        [[NSFileManager defaultManager] attributesOfItemAtPath:[logDirectory stringByAppendingPathComponent:object1]
                                                         error:nil];
        NSDate *date1 = [attributes1 objectForKey:NSFileModificationDate];
        NSDictionary *attributes2 =
        [[NSFileManager defaultManager] attributesOfItemAtPath:[logDirectory stringByAppendingPathComponent:object2]
                                                         error:nil];
        NSDate *date2 = [attributes2 objectForKey:NSFileModificationDate];
        return [date2 compare:date1];
    }];
    
    NSMutableArray *lis = [NSMutableArray array];
    for (int i = 0; i < files.count; i++) {
        NSString *li =
        [NSString stringWithFormat:@"<li><a href=\"javascript:window.location.href=window.location.href + '?index=%d&length=10000'\">%@</a> <a href=\"javascript:window.location.href=window.location.href + '?index=%d'\">[全部]</a></li>", i, files[i], i];
        [lis addObject:li];
    }
    [body appendString:[lis componentsJoinedByString:@""]];
    [body appendString:@"</ul>"];
    return body;
}

- (NSString *)logFileContent:(NSInteger)index length:(NSInteger)length {
    NSString *request = length > 0
    ? [NSString stringWithFormat:@"接收请求：获取顺序为%d的日志文件内容最后%d字", (int)index, (int)length]
    : [NSString stringWithFormat:@"接收请求：获取顺序为%d的日志全部文件内容", (int)index];
    LogInfo(request, nil);
    if ([_delegate respondsToSelector:@selector(webServer:received:)]) {
        [_delegate webServer:self received:request];
    }
    
    NSMutableString *body = [NSMutableString string];
    NSString *logDirectory = [SRRNKit sharedInstance].logger.directory;
    NSError *error = nil;
    NSArray *files =
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logDirectory
                                                        error:&error];
    if (error) {
        [body appendFormat:@"<h2>获取日志文件列表失败</h2><p>%@</p>", error.description];
        return body;
    }
    
    if (files.count < index + 1) {
        [body appendString:@"<h2>无法获取日志文件，请刷新日志文件列表</h2>"];
        return body;
    }
    
    //按照修改时间排序
    files = [files sortedArrayUsingComparator:^NSComparisonResult(id object1, id object2) {
        NSDictionary* attributes1  =
        [[NSFileManager defaultManager] attributesOfItemAtPath:[logDirectory stringByAppendingPathComponent:object1]
                                                         error:nil];
        NSDate *date1 = [attributes1 objectForKey:NSFileModificationDate];
        NSDictionary *attributes2 =
        [[NSFileManager defaultManager] attributesOfItemAtPath:[logDirectory stringByAppendingPathComponent:object2]
                                                         error:nil];
        NSDate *date2 = [attributes2 objectForKey:NSFileModificationDate];
        return [date2 compare:date1];
    }];
    
    NSString *fileName = files[index];
    NSString *filePath = [logDirectory stringByAppendingPathComponent:fileName];
    [body appendString:[NSString stringWithFormat:@"<h2>%@</h2>", fileName]];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (error) {
        [body appendString:[NSString stringWithFormat:@"<p>无法读取文件内容，错误原因: <br>%@</p>", error.description]];
        return body;
    }
    
    request = length > 0
    ? [NSString stringWithFormat:@"接收请求：获取日志文件%@最后%d字", fileName, (int)length]
    : [NSString stringWithFormat:@"接收请求：获取日志文件%@全部内容", fileName];
    LogInfo(request, nil);
    if ([_delegate respondsToSelector:@selector(webServer:received:)]) {
        [_delegate webServer:self received:request];
    }
    
    if (length > 0 && fileContents.length > length) {
        fileContents = [fileContents substringFromIndex:fileContents.length - length];
    }
    
    return fileContents;
}

@end
