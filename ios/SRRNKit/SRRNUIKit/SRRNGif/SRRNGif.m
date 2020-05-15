//
//  SRRNGif.m
//  SRRNKit
//
//  Created by Gary on 2020/4/30.
//  Copyright © 2020 Sharow Roland. All rights reserved.
//

#import "SRRNGif.h"

@implementation SRRNGif

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        NSArray *images = dic[@"images"];
        NSMutableArray *arr = [NSMutableArray array];
        if ([images isKindOfClass:NSArray.class]) {
            for (id element in images) {
                UIImage *image;
                if ([element isKindOfClass: UIImage.class]) {
                    image = (UIImage *)element;
                } else if ([element isKindOfClass:NSString.class]) {
                    NSString *path = [kDocumentsDirectory stringByAppendingString:(NSString *)element];
                    BOOL isDirectory = NO;
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
                        image = [UIImage imageWithContentsOfFile:path];
                    }
                    if (!image) {
                        image = [UIImage imageNamed:(NSString *)element];
                    }
                }
                if (image) {
                    [arr addObject:image];
                }
            }
        }
        self.images = arr;
        
        UIImage *image = self.images.firstObject;
        if (image) {
            self.width = image.size.width;
            self.height = image.size.height;
        }
        
        id value = dic[@"width"];
        if (value) {
            self.width = [value floatValue];
        }
        
        value = dic[@"height"];
        if (value) {
            self.height = [value floatValue];
        }
        
        value = dic[@"duration"];
        if (value) {
            self.duration = [value doubleValue];
        }
    }
    return self;
}

@end
