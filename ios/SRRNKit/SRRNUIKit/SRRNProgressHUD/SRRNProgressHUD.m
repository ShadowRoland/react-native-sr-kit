//
//  SRRNProgressHUD.m
//  SRRNKit
//
//  Created by Gary on 2020/4/30.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SRRNProgressAppearance ()
    
@end

@implementation SRRNProgressAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (appearance && self != appearance) {
            self.progressType = appearance.progressType;
            self.maskColor = appearance.maskColor;
            self.marginTop = appearance.marginTop;
            self.marginBottom = appearance.marginBottom;
            self.marginLeft = appearance.marginLeft;
            self.marginRight = appearance.marginRight;
            self.animated = appearance.animated;
            self.progress = appearance.progress;
            self.showPercentage = appearance.showPercentage;
            self.gif = appearance.gif;
        } else {
            self.maskColor = [UIColor colorWithWhite:0.8f alpha:0.5f];
            self.animated = YES;
        }
    }
    return self;
}

static SRRNProgressAppearance *appearance = nil;

#pragma mark - UIAppearance

+ (instancetype)appearance {
    if (!appearance) {
        appearance = [SRRNProgressAppearance new];
    }
    return appearance;
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait {
    return [SRRNProgressAppearance appearance];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    return [SRRNProgressAppearance appearance];
}


+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    return [SRRNProgressAppearance appearance];
}


+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    return [SRRNProgressAppearance appearance];
}

#pragma clang diagnostic pop

+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    return [SRRNProgressAppearance appearance];
}


@end

@interface SRRNProgressHUD ()
@property (nonatomic, strong) MBProgressHUD *mbProgressHUD;
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, strong) SRRNGif *animationGif;
@end

@implementation SRRNProgressHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appearance = [SRRNProgressAppearance new];
        self.animationGif = nil;
    }
    return self;
}

+ (SRRNProgressHUD *)hud:(SRRNProgressType)progressType {
    switch (progressType) {
        case SRRNProgressTypeInfinite:
            return [SRRNProgressHUD infiniteHUD];
            
        default:
            return nil;
    }
}

+ (SRRNProgressHUD *)infiniteHUD {
    SRRNProgressHUD *hud = [SRRNProgressHUD new];
    hud.appearance.progressType = SRRNProgressTypeInfinite;
    hud.animationImageView = [UIImageView new];
    hud.mbProgressHUD = [[MBProgressHUD alloc] initWithView:hud.animationImageView];
    hud.mbProgressHUD.customView = hud.animationImageView;
    hud.mbProgressHUD.margin = 0;
    hud.mbProgressHUD.mode = MBProgressHUDModeCustomView;
    hud.mbProgressHUD.removeFromSuperViewOnHide = NO;
    hud.mbProgressHUD.bezelView.color = [UIColor clearColor];
    hud.mbProgressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.mbProgressHUD.backgroundView.color = [UIColor clearColor];
    hud.mbProgressHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.hudView = hud.mbProgressHUD;
    return hud;
}

- (void)show:(UIView *)inView {
    if (!inView) {
        return;
    }
    
    UIView *superview = self.hudView.superview;
    SRRNProgressAppearance *appearance = self.appearance;
    superview.backgroundColor = appearance.maskColor;
    switch (appearance.progressType) {
        case SRRNProgressTypeInfinite:
            if (!superview || superview != inView) {
                [self.animationImageView stopAnimating];
                [self.mbProgressHUD hideAnimated:NO];
                [self.mbProgressHUD removeFromSuperview];
                [inView addSubview:self.mbProgressHUD];
                [self.mbProgressHUD mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.offset(0);
                }];
                [self reloadGif];
                [self.mbProgressHUD showAnimated:appearance.animated];
            } else {
                [self reloadGif];
            }
            break;;
            
        default:
            break;;
    }
}

- (void)dismiss:(BOOL)animated {
    SRRNProgressAppearance *appearance = self.appearance;
    switch (appearance.progressType) {
        case SRRNProgressTypeInfinite:
            [self.animationImageView stopAnimating];
            [self.mbProgressHUD hideAnimated:animated];
            break;;
            
        default:
            break;;
    }
}

- (void)reloadGif {
    SRRNProgressAppearance *appearance = self.appearance;
    if (_animationGif == appearance.gif) {
        return;
    }

    self.animationGif = appearance.gif;
    UIImageView *imageView = self.animationImageView;
    [imageView stopAnimating];
    CGRect frame = imageView.frame;
    frame.size.width = _animationGif.width;
    frame.size.height = _animationGif.height;
    imageView.frame = frame;
    NSArray *images = _animationGif.images;
    if (images.count > 1 && _animationGif.duration > 0) {
        imageView.image = nil;
        imageView.animationImages = images;
        imageView.animationDuration = _animationGif.duration;
        [imageView startAnimating];
    } else if (images.count > 0) {
        imageView.image = images.firstObject;
        imageView.animationImages = nil;
        imageView.animationDuration = 0.f;
    }
}

@end
