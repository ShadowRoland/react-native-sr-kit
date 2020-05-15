//
//  SRRNBaseViewController.h
//  SRRNKit
//
//  Created by Gary on 2020/4/22.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTRootView.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRRNViewController : UIViewController
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) RCTRootView *rctRootView;

+ (void)setDefaultRCTBridge:(RCTBridge *)bridge
                 moduleName:(NSString *)moduleName
          initialProperties:(NSDictionary *)initialProperties;

- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties;
@end

NS_ASSUME_NONNULL_END
