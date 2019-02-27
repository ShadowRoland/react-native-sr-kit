//
//  NSString+SRRNKit.m
//  SRRNKit
//
//  Created by Gary on 2019/2/27.
//  Copyright © 2019 Sharow Roland. All rights reserved.
//

#import "NSString+SRRNKit.h"

@implementation NSString (SRRNKit)

//"   aa bb   " -> "aabb"
- (NSString *)condense {
    NSArray *components =
    [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components =
    [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    return [components componentsJoinedByString:@""];
}

//"   aa bb   " -> "aa bb"
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
