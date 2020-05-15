//
//  SRRNBaseViewController.m
//  SRRNKit
//
//  Created by Gary on 2020/4/22.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNViewController.h"
#import <Masonry/Masonry.h>
#import <React/RCTUIManager.h>

@interface SRRNViewController ()
@property (nonatomic, strong) RCTBridge *rctBridge;
@property (nonatomic, strong) NSString *rctModuleName;
@property (nonatomic, strong) NSDictionary *rctInitialProperties;
@end

@implementation SRRNViewController

static RCTBridge *rctBridge = nil;
static NSString *rctModuleName = nil;
static NSDictionary *rctInitialProperties = nil;

+ (void)setDefaultRCTBridge:(RCTBridge *)bridge
                 moduleName:(NSString *)moduleName
          initialProperties:(NSDictionary *)initialProperties {
    rctBridge = bridge;
    rctModuleName = moduleName;
    rctInitialProperties = initialProperties;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self rctInitial];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self rctInitial];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self rctInitial];
    }
    return self;
}

- (void)rctInitial {
    self.rctBridge = rctBridge;
    self.rctModuleName = rctModuleName;
    self.rctInitialProperties = rctInitialProperties;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties {
    self = [super init];
    if (self) {
        self.rctBridge = bridge;
        self.rctModuleName = moduleName;
        self.rctInitialProperties = initialProperties;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_rctBridge) {
        [self.view addSubview:self.rctRootView];
        [self.rctRootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
}

- (RCTRootView *)rctRootView {
    if (_rctRootView) {
        return _rctRootView;
    }

    _rctRootView = [[RCTRootView alloc] initWithBridge:_rctBridge
                                            moduleName:_rctModuleName
                                     initialProperties:_rctInitialProperties];
    return _rctRootView;
}

@end
