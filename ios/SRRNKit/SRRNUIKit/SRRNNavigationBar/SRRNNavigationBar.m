//
//  SRRNNavigationBar.m
//  SRRNKit
//
//  Created by Gary on 2020/3/17.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNNavigationBar.h"
#import <Masonry/Masonry.h>
#import "SRRNKit.h"

@interface SRRNNavigationBar ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIColor *barBackgroundColor;
@property (nonatomic, strong) NSDictionary<NSNumber *, UIImage *> *backgroundImageDictionary;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIVisualEffectView *backgroundBlurView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *backgroundShadowImageView;

@property (nonatomic, assign) UIInterfaceOrientation statusBarOrientation;
@end

@implementation SRRNNavigationBar

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(barStyle, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(barTintColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(isTranslucent, BOOL)
RCT_EXPORT_VIEW_PROPERTY(titleTextAttributes, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(leftBarButtonItems, NSArray)
RCT_EXPORT_VIEW_PROPERTY(rightBarButtonItems, NSArray)
RCT_EXPORT_VIEW_PROPERTY(shadowImage, UIImage)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    if (_barBackgroundColor) {
        return;
    }
    
    UIImageView *imageView = self.backgroundShadowImageView;
    imageView.image = nil;
    imageView.backgroundColor = [UIColor colorWithWhite:221.f / 255.f alpha:0.5];
    [imageView removeFromSuperview];
    [self.backgroundView insertSubview:imageView atIndex:0];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(imageView.superview.mas_leading);
        make.trailing.equalTo(imageView.superview.mas_trailing);
        make.top.equalTo(imageView.superview.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [UIView new];
        [self insertSubview:view aboveSubview:self.backgroundView];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        _contentView = view;
    }
    return _contentView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        UIView *view = [UIView new];
        [self insertSubview:view atIndex:0];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        _backgroundView = view;
    }
    return _backgroundView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImageView *imageView = [UIImageView new];
        [self.backgroundView insertSubview:imageView atIndex:0];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        _backgroundImageView = imageView;
    }
    return _backgroundImageView;
}

- (UIImageView *)backgroundShadowImageView {
    if (!_backgroundShadowImageView) {
        _backgroundShadowImageView = [UIImageView new];
    }
    return _backgroundShadowImageView;
}

- (void)setShadowImage:(UIImage *)shadowImage {
    _shadowImage = shadowImage;
    UIImage *image = _shadowImage;
    UIImageView *imageView = self.backgroundShadowImageView;
    if (image && image.size.width > 0 && image.size.height > 0) {
        imageView.image = image;
            [self.backgroundView insertSubview:imageView atIndex:0];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(imageView.superview.mas_leading);
                make.trailing.equalTo(imageView.superview.mas_trailing);
                make.top.equalTo(imageView.superview.mas_bottom);
                 make.height.mas_equalTo(imageView.mas_width).multipliedBy(image.size.height / image.size.width);
            }];
    } else {
        imageView.image = nil;
        [imageView removeFromSuperview];
    }
    [self layout];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (void)setBarStyle:(UIBarStyle)barStyle {
    _barStyle = barStyle;
    if (_barStyle == UIBarStyleBlack) {
        self.tintColor = [UIColor whiteColor];
        self.barBackgroundColor = [UIColor blackColor];
    } else {
        self.tintColor = [UIColor blackColor];
        self.barBackgroundColor = [UIColor whiteColor];
    }
    [self initBackgroundBlurView];
    [self layout];
}

- (void)initBackgroundBlurView {
    UIBlurEffectStyle effectStyle = _barStyle == UIBarStyleBlack ? UIBlurEffectStyleDark : UIBlurEffectStyleExtraLight;
    [_backgroundBlurView removeFromSuperview];
    self.backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:effectStyle]]];
    _backgroundBlurView.alpha = 1.f;
    [self.backgroundView insertSubview:_backgroundBlurView atIndex:0];
    [_backgroundBlurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)layout {
    UIView *contentView = self.contentView;
    for (UIView *view in contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat contentPadding = 8.f;
    
    // Layout left items
    CGFloat leftWidth = contentPadding;
    UIView *leftPrevious;
    NSArray<UIBarButtonItem *> *items = self.navigationItem.leftBarButtonItems;
    NSUInteger count = items.count;
    for (NSInteger i = 0; i < count; i++) {
        UIView *customView = items[i].customView;
        if (customView) {
            [contentView addSubview:customView];
            CGFloat width = customView.intrinsicContentSize.width;
            if (width == 0) {
                width = customView.frame.size.width;
            }
            [customView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(contentView.mas_top);
                make.bottom.mas_equalTo(contentView.mas_bottom);
                make.width.mas_equalTo(width);
            }];
            if (!leftPrevious) {
                [customView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(contentView.mas_leading).offset(contentPadding);
                }];
            } else {
                [customView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(leftPrevious.mas_trailing);
                }];
            }

            leftWidth += width;
            leftPrevious = customView;
        }
    }

    // Layout right items
    CGFloat rightWidth = contentPadding;
    UIView *rightPrevious;
    items = self.navigationItem.rightBarButtonItems;
    count = items.count;
    for (NSInteger i = 0; i < count; i++) {
        UIView *customView = items[count - 1 - i].customView;
        if (customView) {
            [contentView addSubview:customView];
            CGFloat width = customView.intrinsicContentSize.width;
            if (width == 0) {
                width = customView.frame.size.width;
            }
            [customView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(contentView.mas_top);
                make.bottom.mas_equalTo(contentView.mas_bottom);
                make.width.mas_equalTo(width);
            }];
            if (!rightPrevious) {
                [customView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(contentView.mas_trailing).offset(-contentPadding);
                }];
            } else {
                [customView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(rightPrevious.mas_leading);
                }];
            }

            rightWidth += width;
            rightPrevious = customView;
        }
    }

    // Layout titleView
    UIView *titleView;
    if (_navigationItem.titleView) {
        titleView = titleView;
        self.titleLabel.hidden = YES;
    } else {
        titleView = self.titleLabel;
        self.titleLabel.hidden = NO;
        NSString *title = self.navigationItem.title;
        if (title.length > 0) {
            self.titleLabel.textColor = self.tintColor;
            if (self.titleTextAttributes.count > 0) {
                self.titleLabel.attributedText =
                [[NSAttributedString alloc] initWithString:title attributes:self.titleTextAttributes];
            } else {
                self.titleLabel.text = title;
            }
        } else {
            self.titleLabel.text = nil;
        }
    }
    
    [contentView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_top);
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
    
    CGFloat autoWidth = titleView.intrinsicContentSize.width;
    CGFloat titleMargin = MAX(leftWidth, rightWidth);
    if (titleMargin > contentPadding) {
        titleMargin += contentPadding;
    }
    if (autoWidth > 0) {
        NSLayoutConstraint *leading =
                [NSLayoutConstraint constraintWithItem:titleView
        attribute:NSLayoutAttributeLeft
        relatedBy:NSLayoutRelationGreaterThanOrEqual
        toItem:contentView
                                             attribute:NSLayoutAttributeLeft
                                            multiplier:1.0
        constant:titleMargin];
        leading.priority = UILayoutPriorityDefaultLow;
        [contentView addConstraint:leading];
        
        NSLayoutConstraint *trailing =
                [NSLayoutConstraint constraintWithItem:titleView
        attribute:NSLayoutAttributeRight
        relatedBy:NSLayoutRelationLessThanOrEqual
        toItem:contentView
                                             attribute:NSLayoutAttributeRight
                                            multiplier:1.0
        constant:-titleMargin];
        trailing.priority = UILayoutPriorityDefaultLow;
        [contentView addConstraint:trailing];
    } else {
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(titleView.frame.size.width);
        }];
    }

    [self layoutBackground];
    [self layoutIfNeeded];
}

- (void)layoutBackground {
    // Layout background
    if (@available(iOS 13.0, *)) {
        self.statusBarOrientation = self.window.windowScene.interfaceOrientation;
    } else {
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        self.statusBarOrientation = UIApplication.sharedApplication.statusBarOrientation;
        #pragma GCC diagnostic pop
    }
    UIImage *image;
    if (UIInterfaceOrientationIsPortrait(_statusBarOrientation)) {
        image = _backgroundImageDictionary[@(UIBarMetricsDefault)];
    } else {
        image = _backgroundImageDictionary[@(UIBarMetricsCompact)];
    }
    
    UIView *view = self.backgroundView;
    if (!self.backgroundBlurView) {
        [self initBackgroundBlurView];
    }
    UIVisualEffectView *blurView = self.backgroundBlurView;
    UIImageView *imageView = self.backgroundImageView;
    if (image) {
        view.backgroundColor = nil;
        blurView.hidden = !_isTranslucent;
        imageView.image = image;
        imageView.hidden = NO;
    } else {
        imageView.hidden = YES;
        if (_barTintColor) {
            view.backgroundColor = _barTintColor;
            blurView.hidden = !_isTranslucent;
        } else {
            if (_isTranslucent) {
                view.backgroundColor = nil;
                blurView.hidden = NO;
            } else {
                view.backgroundColor = _barBackgroundColor;
                blurView.hidden = YES;
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIInterfaceOrientation statusBarOrientation;
    if (@available(iOS 13.0, *)) {
        statusBarOrientation = self.window.windowScene.interfaceOrientation;
    } else {
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        statusBarOrientation = UIApplication.sharedApplication.statusBarOrientation;
        #pragma GCC diagnostic pop
    }
    if (statusBarOrientation != _statusBarOrientation) {
        [self layoutBackground];
    }
}
    
@end
