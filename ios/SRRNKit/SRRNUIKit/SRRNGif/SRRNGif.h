//
//  SRRNGif.h
//  SRRNKit
//
//  Created by Gary on 2020/4/30.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface SRRNGif : NSObject
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) NSTimeInterval duration;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
