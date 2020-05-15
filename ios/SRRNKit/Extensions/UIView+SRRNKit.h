//
//  UIView+SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2020/4/30.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@class ViewSRRNProgressComponent;

@interface UIView (SRRNKit)
@property (nonatomic, strong) ViewSRRNProgressComponent *srrnProgressComponent;
@property (nonatomic, assign, readonly) BOOL isShowingSRRNProgress;
- (void)srrnShowProgress:(NSDictionary *)appearance;
- (void)srrnDismissProgress:(BOOL)animated;
@end

@interface ViewSRRNProgressComponent : NSObject
@property (nonatomic, weak) UIView *decorator;
@property (nonatomic, assign, readonly) BOOL isShowing;
- (void)showProgress:(NSDictionary *)appearance;
- (void)dismissProgress:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
