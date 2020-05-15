//
//  UINavigationController+SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2020/4/27.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "UIViewController+SRRNKit.h"

NS_ASSUME_NONNULL_BEGIN

@class NavigationControllerSRRNModalComponent;

@interface UINavigationController (SRRNKit)
@property (nonatomic, strong) NavigationControllerSRRNModalComponent *srrnModalComponent;
@property (nonatomic, copy) void (^ srrnModalDismissedCompletion)(void);
@property (nonatomic, weak) UIViewController *srrnModalViewController;
+ (UINavigationController *)srrnModalViewController:(UIViewController *)viewController
                          navigationControllerClass:(Class)aClass;
@end

@interface NavigationControllerSRRNModalComponent : NSObject
@property (nonatomic, copy) void (^ dimissedCompletion)(void);
@property (nonatomic, weak) UIViewController *modalViewController;
@end

NS_ASSUME_NONNULL_END
