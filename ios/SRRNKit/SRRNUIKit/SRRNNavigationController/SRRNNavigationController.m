//
//  SRRNNavigationController.m
//  SRRNKit
//
//  Created by Gary on 2020/4/27.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNNavigationController.h"
#import "UIViewController+SRRNKit.h"
#import "UINavigationController+SRRNKit.h"

@interface SRRNNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end

@implementation SRRNNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (UIPanGestureRecognizer *)panRecognizer {
    if (_panRecognizer) {
        return _panRecognizer;
    }
        
    _panRecognizer = [UIPanGestureRecognizer new];
    _panRecognizer.delegate = self;
    _panRecognizer.maximumNumberOfTouches = 1;
    
    /**
     *  获取系统手势的target数组
     */
    NSMutableArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"_targets"];
    /**
     *  获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
     */
    id gestureRecognizerTarget = [targets firstObject];
    /**
     *  获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
     */
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    /**
     *  通过前面的打印，我们从控制台获取出来它的方法签名。
     */
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    /**
     *  创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
     */
    [_panRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
    
    return _panRecognizer;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    __weak typeof(self) weakSelf = self;
    [super dismissViewControllerAnimated:flag completion: ^{
        if (weakSelf && weakSelf.srrnModalDismissedCompletion) {
            weakSelf.srrnModalDismissedCompletion();
        }
        completion();
    }];
}

#pragma mark - Orientations

- (BOOL)shouldAutorotate {
    UIViewController *viewController = self.topViewController;
    return viewController ? viewController.shouldAutorotate : super.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *viewController = self.topViewController;
    return viewController ? viewController.supportedInterfaceOrientations : super.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *viewController = self.topViewController;
    return viewController ? viewController.preferredInterfaceOrientationForPresentation : super.preferredInterfaceOrientationForPresentation;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *viewController = self.topViewController;
    return viewController ? viewController.preferredStatusBarStyle : super.preferredStatusBarStyle;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count == 1 || [[self valueForKey:@"_isTransitioning"] boolValue]) {
        //1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
        return NO;
    } else if (gestureRecognizer == self.interactivePopGestureRecognizer && self.topViewController) {
        return self.topViewController.srrnPageBackGestureStyle & SRRNPageBackGestureStyleEdge;
    } else {
        return YES;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    self.pageSwipeEnabled = viewController.srrnPageBackGestureStyle & SRRNPageBackGestureStylePage & ~SRRNPageBackGestureStyleEdge;
}

@end
