//
//  SFRectCornerMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFCornerImageMaker.h"
#import "SFBlockImageMaker.h"
@implementation SFCornerImageMaker
- (instancetype)init
{
    self = [super init];
    self.fillColor = [UIColor clearColor];
    self.dependencies = [NSMutableArray array];
    return self;
}
- (BOOL)isEnable{
    return self.position != 0 && self.radius != 0;
}
- (UIImage *)process:(UIImage *)target{
    if (!self.isEnable) return target;
    UIGraphicsBeginImageContextWithOptions(target.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, target.size.width, target.size.height);
    [self.fillColor setFill];
    CGContextFillRect(context, rect);
    //利用贝塞尔曲线裁剪矩形
    if (self.radius != 0) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:self.position cornerRadii:CGSizeMake(self.radius, self.radius)];
        [path addClip];
    }
    //绘制图像
    [target drawInRect:rect];
    //获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (nonnull NSString *)identifier {
    return self.isEnable ? [NSString stringWithFormat:@"rectCorner_%@_%@",@(self.radius),@(self.position)]:@"";
}
- (void)saveContext {
    _fillColor = [UIColor colorWithCGColor:_fillColor.CGColor];
}
@end

@implementation SFCircleImageMaker
- (BOOL)isEnable{
    return YES;
}
- (UIImage *)process:(UIImage *)target{
    if (ceil(target.size.width) != ceil(target.size.height)) {
        target = [[SFBlockImageMaker centerSquare] process:target];
    }
    self.position = UIRectCornerAllCorners;
    self.radius = target.size.width * 0.5;
    return [super process:target];
}
- (NSString *)identifier{
    return @"circle";
}
@end
