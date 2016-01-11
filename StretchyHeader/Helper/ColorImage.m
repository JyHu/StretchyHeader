//
//  ColorImage.m
//  AspectHeader
//
//  Created by 胡金友 on 15/9/16.
//  Copyright (c) 2015年 胡金友. All rights reserved.
//

#import "ColorImage.h"

@implementation UIImage(ColorImage)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
