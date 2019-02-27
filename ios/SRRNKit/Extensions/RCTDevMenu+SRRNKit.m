//
//  RCTDevMenu+SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2019/2/27.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "RCTDevMenu+SRRNKit.h"

@implementation RCTDevMenu (SRRNKit)

- (NSArray<RCTDevMenuItem *> *)newMenuItems {
    NSMutableArray<RCTDevMenuItem *> *items = (NSMutableArray *)[self newMenuItems];
    RCTDevMenuItem *item = [RCTDevMenuItem buttonItemWithTitle:@"RNKit Debug" handler:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)RNKitMenuItemClicked
                                                            object:nil
                                                          userInfo:nil];
        
    }];
    [items addObject: item];
    return items;
}

@end
