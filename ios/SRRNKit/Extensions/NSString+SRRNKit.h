//
//  NSString+SRRNKit.h
//  SRRNKit
//
//  Created by Gary on 2019/2/27.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SRRNKit)
- (NSString *)srrnCondense;
- (NSString *)srrnTrim;
@property (nonatomic, strong, readonly) UIColor *srrnColor;
@end

NS_ASSUME_NONNULL_END
