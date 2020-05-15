//
//  SRRNNavigationItem.m
//  SRRNKit
//
//  Created by Gary on 2020/3/17.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNNavigationItem.h"
#import "SRRNNavigationBar.h"

@interface SRRNNavigationItem () {
    NSString *_title;
    UIView *_titleView;
    NSArray<UIBarButtonItem *> *_leftBarButtonItems;
    NSArray<UIBarButtonItem *> *_rightBarButtonItems;
    
    UIBarButtonItem *_backBarButtonItem;
    BOOL _hidesBackButton;
    BOOL _leftItemsSupplementBackButton;
    
    NSString *_prompt;
}

@end

@implementation SRRNNavigationItem

- (NSString *)title {
    return _title;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.navigationBar layout];
}

- (UIView *)titleView {
    return _titleView;
}

- (void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
    [self.navigationBar layout];
}

- (NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    return _leftBarButtonItems;
}

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    _leftBarButtonItems = leftBarButtonItems;
    [self.navigationBar layout];
}

- (NSArray<UIBarButtonItem *> *)rightBarButtonItems {
    return _rightBarButtonItems;
}

- (void)setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems {
    _rightBarButtonItems = rightBarButtonItems;
    [self.navigationBar layout];
}

- (UIBarButtonItem *)leftBarButtonItem {
    return self.leftBarButtonItems.count == 1 ? self.leftBarButtonItems.firstObject : nil;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    self.leftBarButtonItems = leftBarButtonItem ? @[leftBarButtonItem] : nil;
}

- (UIBarButtonItem *)rightBarButtonItem {
    return self.rightBarButtonItems.count == 1 ? self.rightBarButtonItems.firstObject : nil;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    self.rightBarButtonItems = rightBarButtonItem ? @[rightBarButtonItem] : nil;
}

- (UIBarButtonItem *)backBarButtonItem {
    return _backBarButtonItem;
}

- (void)setBackBarButtonItem:(UIBarButtonItem *)backBarButtonItem {
    _backBarButtonItem = backBarButtonItem;
}

- (BOOL)hidesBackButton {
    return _hidesBackButton;
}

#pragma mark -

- (void)setHidesBackButton:(BOOL)hidesBackButton {
    _hidesBackButton = hidesBackButton;
}

- (BOOL)leftItemsSupplementBackButton {
    return _leftItemsSupplementBackButton;
}

- (void)setLeftItemsSupplementBackButton:(BOOL)leftItemsSupplementBackButton {
    _leftItemsSupplementBackButton = leftItemsSupplementBackButton;
}

- (NSString *)prompt {
    return _prompt;
}

- (void)setPrompt:(NSString *)prompt {
    _prompt = prompt;
}

@end
