//
//  UIViewController+SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2020/4/27.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "UIViewController+SRRNKit.h"
#import <objc/runtime.h>
#import "NSObject+SRRNKit.h"
#import "UINavigationController+SRRNKit.h"

@implementation UIViewController (SRRNKit)

static const void *kSRRNBaseComponent = &kSRRNBaseComponent;

- (ViewControllerSRRNBaseComponent *)srrnBaseComponent {
    id component = objc_getAssociatedObject(self, kSRRNBaseComponent);
    if (component) {
        return component;
    } else {
        [self setSrrnBaseComponent:[ViewControllerSRRNBaseComponent new]];
        return objc_getAssociatedObject(self, kSRRNBaseComponent);
    }
}

- (void)setSrrnBaseComponent:(ViewControllerSRRNBaseComponent *)srrnBaseComponent {
    objc_setAssociatedObject(self,
                             kSRRNBaseComponent,
                             srrnBaseComponent,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)srrnParams {
    return self.srrnBaseComponent.params;
}

- (void)setSrrnParams:(NSDictionary *)srrnParams {
    [self.srrnBaseComponent.params removeAllObjects];
    [self.srrnBaseComponent.params addEntriesFromDictionary:srrnParams];
}

- (void)srrnPageBack {
    [self srrnPageBack:YES];
}

- (void)srrnPageBack:(BOOL)animated {
    UINavigationController *navigationController = self.navigationController;
    if (navigationController) {
        if (navigationController.srrnModalViewController == self) {
            [navigationController dismissViewControllerAnimated:animated completion:nil];
        } else {
            [navigationController popViewControllerAnimated:animated];
        }
    } else if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:animated completion:nil];
    }
}

- (void)srrnPageBackToViewController:(UIViewController *)viewController
                            animated:(BOOL)animated
                       dismissModals:(BOOL)dismissModals {
    UINavigationController *navigationController = self.navigationController;
    if (dismissModals) {
        NSMutableArray *array = [NSMutableArray array];
        BOOL isMatched = NO;
        for (UIViewController *vc in navigationController.viewControllers.reverseObjectEnumerator) {
            if (vc != viewController) {
                [array addObject:vc];
            } else {
                isMatched = YES;
            }
        }
        if (isMatched) {
            for (UIViewController *vc in array) {
                [UIViewController srrnDismissModal:vc.presentedViewController];
            }
        }
    }
    [navigationController popToViewController:viewController animated:animated];
}

- (SRRNPageBackGestureStyle)srrnPageBackGestureStyle {
    return self.srrnBaseComponent.pageBackGestureStyle;
}

- (void)setSrrnPageBackGestureStyle:(SRRNPageBackGestureStyle)srrnPageBackGestureStyle {
    self.srrnBaseComponent.pageBackGestureStyle = srrnPageBackGestureStyle;
}

- (BOOL)srrnIsTop {
    UIViewController *top = [UIViewController srrnTop];
    if (self == top) {
        return YES;
    } else if ([top isKindOfClass:UINavigationController.class]
               && self == [(UINavigationController *)top topViewController]) {
        return YES;
    } else {
        return NO;
    }
}

+ (UIWindow *)srrnCurrentWindow {
    if (@available(iOS 13.0, *)) {
        
    } else {
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow && keyWindow.windowLevel == UIWindowLevelNormal) {
            return keyWindow;
        }
        #pragma GCC diagnostic pop
    }

    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    }

    return nil;
}

+ (UIViewController *)srrnTop {
    return [UIViewController srrnTop:[[UIViewController srrnCurrentWindow] rootViewController]];
}

+ (UIViewController *)srrnTop:(UIViewController *)viewController {
    if (!viewController) {
        return nil;
    }

    UIViewController *presentedViewController = viewController.presentingViewController;
    if (presentedViewController) {
        return [UIViewController srrnTop:presentedViewController];
    }

    if ([viewController isKindOfClass:UITabBarController.class]) {
        UIViewController *selectedViewController =
            [(UITabBarController *)viewController selectedViewController];
        if (selectedViewController) {
            return [UIViewController srrnTop:selectedViewController];
        }
    }

    if ([viewController isKindOfClass:UINavigationController.class]) {
        UIViewController *visibleViewController =
            [(UINavigationController *)viewController visibleViewController];
        if (visibleViewController) {
            return [UIViewController srrnTop:visibleViewController];
        }
    }

    return viewController;
}

- (void)srrnDismissModals {
    if (self.navigationController) {
        for (UIViewController *viewController in self.navigationController.viewControllers.reverseObjectEnumerator) {
            [UIViewController srrnDismissModal:viewController.presentedViewController];
        }
    } else if ([self isKindOfClass:UINavigationController.class]) {
        for (UIViewController *viewController in [(UINavigationController *)self viewControllers].reverseObjectEnumerator) {
            [UIViewController srrnDismissModal:viewController.presentedViewController];
        }
    } else {
        [UIViewController srrnDismissModal:self.presentedViewController];
    }
}

+ (void)srrnDismissModal:(UIViewController *)presentedViewController {
    [presentedViewController srrnDismissModals];
    void (^ dimissedCompletion)(void);
    if ([presentedViewController isKindOfClass:UINavigationController.class]) {
        dimissedCompletion = [(UINavigationController *)presentedViewController srrnModalDismissedCompletion];
    }
    [presentedViewController dismissViewControllerAnimated:false completion:dimissedCompletion];
}

- (UIViewController *)srrnShow:(id)viewController
                      animated:(BOOL)animated
                        params:(NSDictionary *)params {
    UIViewController *vc = [viewController srrnObjectWithKindOfClass:UIViewController.class];
    if (!vc) {
        return nil;
    }

    UINavigationController *navigationController = self.navigationController;
    if (!navigationController) {
        return nil;
    }

    vc.srrnParams = params;
    [navigationController pushViewController:viewController animated:animated];
    return vc;
}

- (UIViewController *)srrnModal:(id)viewController
           navigationController:(NSString *)navigationController
                       animated:(BOOL)animated
                         params:(NSDictionary *)params
                     completion:(void (^)(void))completion {
    UIViewController *vc = [viewController srrnObjectWithKindOfClass:UIViewController.class];
    if (!vc) {
        return nil;
    }

    vc.srrnParams = params;
    UINavigationController *navigationVC =
    [UINavigationController srrnModalViewController:viewController
                        navigationControllerClass:NSClassFromString(navigationController)];
    vc = navigationVC ? navigationVC : vc;
    
    UIViewController *presentViewController = self.navigationController;
    if (!presentViewController) {
        presentViewController = self;
    }
    [presentViewController presentViewController: vc animated:animated completion:completion];
    
    return vc;
}

- (void)srrnShowProgress:(NSDictionary *)appearance {
    [self.view srrnShowProgress:appearance];
}

- (void)srrnDismissProgress:(BOOL)animated {
    [self.view srrnDismissProgress:animated];
}

@end

@implementation ViewControllerSRRNBaseComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageBackGestureStyle = SRRNPageBackGestureStylePage;
    }
    return self;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

@end
