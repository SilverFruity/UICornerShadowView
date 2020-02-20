//
//  SFColorImageMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFColorImageMaker.h"

@implementation SFColorImageMaker
+ (instancetype)imageMakerWithColor:(UIColor *)color{
    SFColorImageMaker *colorImage = [[self class] new];
    colorImage.color = color;
    colorImage.size = CGSizeMake(1, 1);
    return colorImage;
}
+ (instancetype)imageMakerWithColor:(UIColor *)color size:(CGSize)size{
    SFColorImageMaker *colorImage = [self imageMakerWithColor:color];
    colorImage.size = size;
    return colorImage;
}
- (BOOL)isEnable{
    return self.color != [UIColor clearColor] && !CGSizeEqualToSize(self.size, CGSizeZero);
}
- (UIImage *)general{
    if (!self.isEnable) return [UIImage new];
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextSetAlpha(context, CGColorGetAlpha(self.color.CGColor));
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
