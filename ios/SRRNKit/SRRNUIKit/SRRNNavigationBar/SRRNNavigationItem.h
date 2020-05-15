//
//  SRRNNavigationItem.h
//  SRRNKit
//
//  Created by Gary on 2020/3/17.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class SRRNNavigationBar;

@interface SRRNNavigationItem : UINavigationItem
@property (nonatomic, weak) SRRNNavigationBar *navigationBar;
@end

NS_ASSUME_NONNULL_END
