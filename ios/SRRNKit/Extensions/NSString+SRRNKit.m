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
- (NSString *)srrnCondense {
    NSArray *components =
    [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components =
    [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    return [components componentsJoinedByString:@""];
}

//"   aa bb   " -> "aa bb"
- (NSString *)srrnTrim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (UIColor *)srrnColor {
    NSString *string = [self stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (string.length == 1) {
        return [self srrnColorFull:[NSString stringWithFormat:@"%@%@%@%@%@%@",
                                     string,
                                     string,
                                     string,
                                     string,
                                     string,
                                     string]];
    }
    
    if (string.length == 2) {
        return [self srrnColorFull:[NSString stringWithFormat:@"%@%@%@",
                                     string,
                                     string,
                                     string]];
    }
    
    if (self.length == 6 || self.length == 8) {
        return [self srrnColorFull:string];
    }
    
    return nil;
}

- (UIColor *)srrnColorFull:(NSString *)hexColor {
    unsigned int red, green, blue;
    NSRange range;
    range.length   = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]
     scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]
     scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]
     scanHexInt:&blue];
    unsigned int alpha = 255;
    if (hexColor.length >= 8) {
        range.location = 6;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]
         scanHexInt:&alpha];
    }
    return [UIColor colorWithRed:(float)(red / 255.0f)
                           green:(float)(green / 255.0f)
                            blue:(float)(blue / 255.0f)
                           alpha:(float)(alpha / 255.0f)];
}

@end
