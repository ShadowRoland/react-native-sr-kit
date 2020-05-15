//
//  UIViewController+SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2020/4/27.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS (NSUInteger, SRRNPageBackGestureStyle) {
    SRRNPageBackGestureStyleNone = 0,
    SRRNPageBackGestureStyleEdge = 1 << 0,
    SRRNPageBackGestureStylePage = SRRNPageBackGestureStyleEdge | 1 << 1,
};

@class ViewControllerSRRNBaseComponent;

@interface UIViewController (SRRNKit)
@property (nonatomic, strong) ViewControllerSRRNBaseComponent *srrnBaseComponent;
@property (nonatomic, assign) NSDictionary *srrnParams;
@property (nonatomic, assign) SRRNPageBackGestureStyle srrnPageBackGestureStyle;
@property (nonatomic, assign, readonly) BOOL srrnIsTop;

- (void)srrnPageBack;
- (void)srrnPageBack:(BOOL)animated;
- (void)srrnPageBackToViewController:(UIViewController *)viewController
                            animated:(BOOL)animated
                       dismissModals:(BOOL)dismissModals;
+ (UIWindow *)srrnCurrentWindow;
+ (UIViewController *)srrnTop;
- (void)srrnDismissModals;
- (UIViewController *)srrnShow:(id)viewController
                      animated:(BOOL)animated
                        params:(NSDictionary *)params;
- (UIViewController *)srrnModal:(id)viewController
           navigationController:(NSString *)navigationController
                       animated:(BOOL)animated
                         params:(NSDictionary *)params
                     completion:(void (^)(void))completion;

- (void)srrnShowProgress:(NSDictionary *)appearance;
- (void)srrnDismissProgress:(BOOL)animated;
@end

@interface ViewControllerSRRNBaseComponent : NSObject
@property (nonatomic, assign) NSMutableDictionary *params;
@property (nonatomic, assign) SRRNPageBackGestureStyle pageBackGestureStyle;
@end

NS_ASSUME_NONNULL_END
