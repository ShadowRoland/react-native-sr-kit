//
//  SRRNNavigationBar.h
//  SRRNKit
//
//  Created by Gary on 2020/3/17.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNNavigationItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRRNNavigationBar : UIView
@property (nonatomic, weak) SRRNNavigationItem *navigationItem;
@property (nonatomic, assign) UIBarStyle barStyle;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, assign) BOOL isTranslucent;
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;
@property (nonatomic, strong) NSArray<UIBarButtonItem *> *leftBarButtonItems;
@property (nonatomic, strong) NSArray<UIBarButtonItem *> *rightBarButtonItems;
@property (nonatomic, strong) UIImage *shadowImage;

- (void)layout;
@end

NS_ASSUME_NONNULL_END
