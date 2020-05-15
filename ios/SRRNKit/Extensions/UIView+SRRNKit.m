//
//  UIView+SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2020/4/30.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "UIView+SRRNKit.h"
#import <objc/runtime.h>

@implementation UIView (SRRNKit)

static const void *kSRRNProgressComponent = &kSRRNProgressComponent;

- (ViewSRRNProgressComponent *)srrnProgressComponent {
    id component = objc_getAssociatedObject(self, kSRRNProgressComponent);
    if (component) {
        return component;
    } else {
        ViewSRRNProgressComponent *component = [ViewSRRNProgressComponent new];
        component.decorator = self;
        [self setSrrnProgressComponent:component];
        return objc_getAssociatedObject(self, kSRRNProgressComponent);
    }
}

- (void)setSrrnProgressComponent:(ViewSRRNProgressComponent *)srrnProgressComponent {
    objc_setAssociatedObject(self,
                             kSRRNProgressComponent,
                             srrnProgressComponent,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowingSRRNProgress {
    return [self.srrnProgressComponent isShowing];
}

- (void)srrnShowProgress:(NSDictionary *)appearance {
    [self.srrnProgressComponent showProgress:appearance];
}

- (void)srrnDismissProgress:(BOOL)animated {
    [self.srrnProgressComponent dismissProgress:animated];
}

@end

@interface ViewSRRNProgressComponent () {
    SRRNProgressHUD *_progressHUD;
}
@property (nonatomic, strong) UIView *maskView;
- (void)showProgress:(NSDictionary *)appearance;
- (void)dismissProgress:(BOOL)animated;
@end

@implementation ViewSRRNProgressComponent

- (void)showProgress:(NSDictionary *)appearance {
    if (!_decorator) {
        return;
    }

    SRRNProgressType progressType = SRRNProgressTypeInfinite;
    id value = appearance[@"progressType"];
    if (value) {
        progressType = [value integerValue];
        if (!_progressHUD || progressType != _progressHUD.appearance.progressType) {
            [_progressHUD dismiss:NO];
            _progressHUD = [SRRNProgressHUD hud:progressType];
        }
    }

    if (!_progressHUD) {
        _progressHUD = [SRRNProgressHUD hud:progressType];
    }

    SRRNProgressAppearance *progressAppearance = _progressHUD.appearance;

    value = appearance[@"maskColor"];
    if (value) {
        if ([value isKindOfClass:UIColor.class]) {
            progressAppearance.maskColor = (UIColor *)value;
        } else if ([value isKindOfClass:NSString.class]) {
            progressAppearance.maskColor = [(NSString *)value srrnColor];
        }
    }

    value = appearance[@"animated"];
    if (value) {
        progressAppearance.animated = [value boolValue];
    }

    value = appearance[@"progress"];
    if (value) {
        progressAppearance.progress = [value floatValue];
    }

    value = appearance[@"showPercentage"];
    if (value) {
        progressAppearance.showPercentage = [value boolValue];
    }

    value = appearance[@"gif"];
    if (value) {
        if ([value isKindOfClass:SRRNGif.class]) {
            progressAppearance.gif = (SRRNGif *)value;
        } else if ([value isKindOfClass:NSDictionary.class]) {
            progressAppearance.gif = [[SRRNGif alloc] initWithDictionary:(NSDictionary *)value];
        }
    }

    BOOL isMarginChanged = NO;

    value = appearance[@"marginTop"];
    if (value) {
        CGFloat marginTop = [value floatValue];
        if (marginTop != progressAppearance.marginTop) {
            isMarginChanged = YES;
            progressAppearance.marginTop = marginTop;
        }
    }

    value = appearance[@"marginBottom"];
    if (value) {
        CGFloat marginBottom = [value floatValue];
        if (marginBottom != progressAppearance.marginBottom) {
            isMarginChanged = YES;
            progressAppearance.marginBottom = marginBottom;
        }
    }

    value = appearance[@"marginLeft"];
    if (value) {
        CGFloat marginLeft = [value floatValue];
        if (marginLeft != progressAppearance.marginLeft) {
            isMarginChanged = YES;
            progressAppearance.marginLeft = marginLeft;
        }
    }

    value = appearance[@"marginRight"];
    if (value) {
        CGFloat marginRight = [value floatValue];
        if (marginRight != progressAppearance.marginRight) {
            isMarginChanged = YES;
            progressAppearance.marginRight = marginRight;
        }
    }

    if (self.isShowing) {
        if (isMarginChanged) {
            [self.maskView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_decorator.mas_top).offset(progressAppearance.marginTop);
                make.bottom.equalTo(_decorator.mas_bottom).offset(-progressAppearance.marginBottom);
                make.leading.equalTo(_decorator.mas_leading).offset(progressAppearance.marginLeft);
                make.trailing.equalTo(_decorator.mas_trailing).offset(-progressAppearance.marginRight);
            }];
        }
        [_progressHUD show:self.maskView];
    } else {
        [_decorator addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_decorator.mas_top).offset(progressAppearance.marginTop);
            make.bottom.equalTo(_decorator.mas_bottom).offset(-progressAppearance.marginBottom);
            make.leading.equalTo(_decorator.mas_leading).offset(progressAppearance.marginLeft);
            make.trailing.equalTo(_decorator.mas_trailing).offset(-progressAppearance.marginRight);
        }];
        [_progressHUD show:self.maskView];
    }
}

- (void)dismissProgress:(BOOL)animated {
    if (self.isShowing) {
        [_progressHUD dismiss:animated];
        [_progressHUD.hudView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
    }
    return _maskView;
}

- (BOOL)isShowing {
    return _maskView && _maskView.superview;
}

@end
