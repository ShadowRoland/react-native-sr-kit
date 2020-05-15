//
//  UINavigationController+SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2020/4/27.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "UINavigationController+SRRNKit.h"
#import <objc/runtime.h>

@implementation UINavigationController (SRRNKit)

static const void *kSRRNModalComponent = &kSRRNModalComponent;

- (NavigationControllerSRRNModalComponent *)srrnModalComponent {
    id component = objc_getAssociatedObject(self, kSRRNModalComponent);
    if (component) {
        return component;
    } else {
        [self setSrrnModalComponent:[NavigationControllerSRRNModalComponent new]];
        return objc_getAssociatedObject(self, kSRRNModalComponent);
    }
}

- (void)setSrrnModalComponent:(NavigationControllerSRRNModalComponent *)srrnModalComponent {
    objc_setAssociatedObject(self,
                             kSRRNModalComponent,
                             srrnModalComponent,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))srrnModalDismissedCompletion {
    return self.srrnModalComponent.dimissedCompletion;
}

- (void)setSrrnModalDismissedCompletion:(void (^)(void))srrnModalDismissedCompletion {
    self.srrnModalComponent.dimissedCompletion = srrnModalDismissedCompletion;
}

- (UIViewController *)srrnModalViewController {
    return self.srrnModalComponent.modalViewController;
}

- (void)setSrrnModalViewController:(UIViewController *)srrnModalViewController {
    self.srrnModalComponent.modalViewController = srrnModalViewController;
}

+ (UINavigationController *)srrnModalViewController:(UIViewController *)viewController
                          navigationControllerClass:(Class)aClass {
    if (!viewController || [aClass isSubclassOfClass:UINavigationController.class]) {
        return nil;
    }
    
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view.alpha = 0;
    UINavigationController *navigationController = [aClass alloc];
    navigationController = [navigationController initWithRootViewController:rootViewController];
    [navigationController pushViewController:viewController animated:NO];
    navigationController.srrnModalViewController = viewController;
    return navigationController;
}

@end

@implementation NavigationControllerSRRNModalComponent

@end
