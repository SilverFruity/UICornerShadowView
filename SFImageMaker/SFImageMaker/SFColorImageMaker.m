//
//  SFColorImageMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFColorImageMaker.h"

@implementation SFColorImageMaker
+ (CGSize)defaultSize{
    return CGSizeMake(1, 1);
}
- (instancetype)init{
    self = [[SFColorImageMaker alloc] initWithSize:[[self class] defaultSize]];
    return self;
}
- (nonnull instancetype)initWithSize:(CGSize)size{
    self = [super init];
    self.size = size;
    self.dependencies = [NSMutableArray array];
    return  self;
}
+ (instancetype)imageMakerWithColor:(UIColor *)color{
    SFColorImageMaker *colorImage = [self imageMakerWithColor:color size:CGSizeMake(1, 1)];
    return colorImage;
}
+ (instancetype)imageMakerWithColor:(UIColor *)color size:(CGSize)size{
    SFColorImageMaker *colorImage = [[SFColorImageMaker alloc] initWithSize:size];
    colorImage.color = color;
    return colorImage;
}
- (BOOL)isEnable{
    return self.color != [UIColor clearColor] && !CGSizeEqualToSize(self.size, CGSizeZero);
}
- (nonnull UIImage *)generate {
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
- (nonnull NSString *)identifier {
    return self.isEnable ? [NSString stringWithFormat:@"%@%@",self.color.sf_identifier,[NSValue valueWithCGSize:self.size]] : @"";
}
- (void)saveContext {
    _color = [UIColor colorWithCGColor:_color.CGColor];
}
@end
