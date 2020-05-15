//
//  SRRNProgressHUD.h
//  SRRNKit
//
//  Created by Gary on 2020/4/30.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNGif.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SRRNProgressType) {
    SRRNProgressTypeInfinite,
    SRRNProgressTypeM13Ring,
};

@interface SRRNProgressAppearance : NSObject <UIAppearance>
@property (nonatomic, assign) SRRNProgressType progressType;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) CGFloat marginLeft;
@property (nonatomic, assign) CGFloat marginRight;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL showPercentage;
@property (nonatomic, strong) SRRNGif *gif;
@end


@interface SRRNProgressHUD : NSObject
@property (nonatomic, strong) SRRNProgressAppearance *appearance;
@property (nonatomic, strong) UIView *hudView;
+ (SRRNProgressHUD *)hud:(SRRNProgressType)progressType;
- (void)show:(UIView *)inView;
- (void)dismiss:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
