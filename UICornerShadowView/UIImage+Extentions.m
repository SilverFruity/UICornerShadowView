//
//  UIImage+imageExtention.m
//
//  Created by Jiang on 2017/4/18.
//
//

#import "UIImage+Extentions.h"
#import <ImageIO/ImageIO.h>
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif
#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

#ifndef SCREEN_SCALE
#define SCREEN_SCALE [UIScreen mainScreen].scale
#endif
extern CGRect CGSize2CGRect(CGSize size);

@implementation SFRectCorner
- (instancetype)init
{
    self = [super init];
    self.fillColor = [UIColor clearColor];
    return self;
}
- (BOOL)isEnable{
    return self.position != 0 && self.radius != 0;
}
- (UIImage *)process:(UIImage *)target{
    if (!self.isEnable) return target;
    UIGraphicsBeginImageContextWithOptions(target.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGSize2CGRect(target.size);
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
@end

@implementation SFShadow
- (instancetype)init
{
    self = [super init];
    self.fillColor = [UIColor clearColor];
    return self;
}
- (BOOL)isEnable{
    return self.shadowColor != nil && self.shadowColor != [UIColor clearColor] && self.shadowBlurRadius != 0;
}
- (CGRect)viewRectForSize:(CGSize)size{
    UIEdgeInsets insets = [self convasEdgeInsets];
    CGSize convasSize = [self convasSizeWithSize:size];
    return CGRectMake(-insets.left, -insets.top, convasSize.width, convasSize.height);
}
- (CGSize)convasSizeWithSize:(CGSize)size{
    UIEdgeInsets insets = [self convasEdgeInsets];
    return CGSizeMake(size.width + insets.left + insets.right, size.height + insets.top + insets.bottom);
}
- (UIEdgeInsets)convasEdgeInsets{
    CGFloat left=0, right = 0, top = 0, bottom = 0;
    if (self.position&UIShadowPostionRight&&self.shadowOffset.width>0) {
        right += fabs(self.shadowOffset.width);
    }else if (self.position&UIShadowPostionLeft&&self.shadowOffset.width<0) {
        left += fabs(self.shadowOffset.width);
    }
    if (self.position&UIShadowPostionBottom&&self.shadowOffset.height>0) {
        bottom += fabs(self.shadowOffset.height);
    }else if (self.position&UIShadowPostionTop&&self.shadowOffset.height<0) {
        top += fabs(self.shadowOffset.height);
    }
    top += self.position&UIShadowPostionTop?self.shadowBlurRadius:0;
    bottom += self.position&UIShadowPostionBottom?self.shadowBlurRadius:0;
    left  += self.position&UIShadowPostionLeft?self.shadowBlurRadius:0;
    right  += self.position&UIShadowPostionRight?self.shadowBlurRadius:0;
    return UIEdgeInsetsMake(top, left, bottom, right);
}
- (UIImage *)process:(UIImage *)target{
    if (!self.isEnable) return target;
    UIEdgeInsets insets = [self convasEdgeInsets];
    CGSize canvasSize = [self convasSizeWithSize:target.size];
    CGRect canvasRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    UIGraphicsBeginImageContextWithOptions(canvasRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.fillColor setFill];
    CGContextFillRect(context,canvasRect);
    CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlurRadius, self.shadowColor.CGColor);
    [target drawInRect:CGRectMake(insets.left, insets.top, target.size.width, target.size.height)];
    //获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation SFBorder
- (instancetype)init
{
    self = [super init];
    self.fillColor = [UIColor clearColor];
    return self;
}
- (BOOL)isEnable{
    return self.color != nil && self.color != [UIColor clearColor] && self.width != 0;
}
- (UIEdgeInsets)strokeEdgeInsets{
    CGFloat left=0, right = 0, top = 0, bottom = 0;
    left = self.position&UIBorderPostionLeft? self.width/2 : -self.width/2;
    right = self.position&UIBorderPostionRight? self.width/2 : -self.width/2;
    top = self.position&UIBorderPostionTop?  self.width/2 : -self.width/2;
    bottom = self.position&UIBorderPostionBottom? self.width/2 : -self.width/2;
    return UIEdgeInsetsMake(top, left, bottom, right);
}
- (CGPoint)strokeOrigin{
    UIEdgeInsets insets = [self strokeEdgeInsets];
    return CGPointMake(insets.left, insets.top);
}
- (CGSize)strokeSizeWithSize:(CGSize)size{
    UIEdgeInsets insets = [self strokeEdgeInsets];
    return CGSizeMake(size.width - insets.left - insets.right,size.height - insets.top - insets.bottom);
}
- (CGRect)strokeRectWithSize:(CGSize)size{
    CGPoint origin = [self strokeOrigin];
    CGSize rectSize = [self strokeSizeWithSize:size];
    return CGRectMake(origin.x, origin.y, rectSize.width, rectSize.height);
}
- (UIImage *)process:(UIImage *)target rectCorner:(SFRectCorner *)rectCorner{
    if (!self.isEnable) return target;
    CGRect rect = CGSize2CGRect(target.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.color setStroke];
    [self.fillColor setFill];
    CGContextFillRect(context, rect);
    [target drawInRect:rect];
    if (rectCorner){
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner.position cornerRadii:CGSizeMake(rectCorner.radius, rectCorner.radius)];
        [clipPath addClip];
    }
    
    CGRect strokeRect = CGContextGetClipBoundingBox(context);
    strokeRect = [self strokeRectWithSize:target.size];
    UIBezierPath *linePath;
    if (!rectCorner || self.width > rectCorner.radius || rectCorner.radius == 0){ // 当 width 40 radius 20的情况下
        linePath = [UIBezierPath bezierPathWithRect:strokeRect];
    }else{
        linePath = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:rectCorner.position cornerRadii:CGSizeMake(rectCorner.radius, rectCorner.radius)];
    }
    linePath.lineWidth = self.width;
    if (rectCorner.radius > 0){
        linePath.lineCapStyle = kCGLineCapRound;
        linePath.lineJoinStyle = kCGLineJoinRound;
    }
    [linePath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end


@implementation UIImage (Property)
- (CGFloat)aspectRatio{
    return self.size.width / self.size.height;
}
@end
@implementation UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetAlpha(context, CGColorGetAlpha(color.CGColor));
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)imageRenderWithColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)gradientImage:(BOOL)isHorizontal startColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    CGSize size = isHorizontal ? CGSizeMake(SCREEN_WIDTH, 1) : CGSizeMake(1, SCREEN_HEIGHT);
    return [self linearGradientImage:size isHorizontal:isHorizontal locations:@[@(0),@(1)] startColor:startColor endColor:endColor];
}

+ (UIImage *)linearGradientImage:(CGSize)size
                    isHorizontal:(BOOL)isHorizontal
                       locations:(NSArray <NSNumber *>*)locations
                      startColor:(UIColor *)startColor
                        endColor:(UIColor *)endColor{
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat cLocations[2];
    cLocations[0] = locations.firstObject.doubleValue;
    cLocations[1] = locations.lastObject.doubleValue;
    
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, cLocations);
    
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height), &CGAffineTransformIdentity);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    if (!isHorizontal) {
        startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
        endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    }
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(path);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)centerResizeCircleImage:(UIColor *)color width:(CGFloat)width{
    return [UIImage imageWithColor:color size:CGSizeMake(width, width)].circleImage.resizableImageCenterMode;
}
@end

@implementation UIImage (Radius)
- (UIImage *)centerRectWithAspectRatio:(CGFloat)aspectRatio{
    CGFloat width = floor(self.size.width);
    CGFloat height = floor(self.size.height);
    CGFloat imageAspectRatio = width / height;
    if(imageAspectRatio == aspectRatio) return self;
    CGFloat x = 0, y = 0;
    if (imageAspectRatio < aspectRatio) {
        y = floor((height - width/aspectRatio) * 0.5);
        height = width / aspectRatio;
    }else{
        x = floor((width - height*aspectRatio) * 0.5);
        width = height * aspectRatio;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(x, y, width, height));
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return newImage;
}
- (UIImage *)centerSquare{
    return [self centerRectWithAspectRatio:1.0];
}

- (UIImage *)circleImage{
    UIImage *image = self;
    if (ceil(self.size.width) != ceil(self.size.height)) {
        image = [self centerSquare];
    }
    return [image cornerImageWithCornerRadius:image.size.width * 0.5];
}

- (UIImage *)cornerImageWithCornerRadius:(CGFloat)radius{
    return [self cornerImageWithRoundingCorners:UIRectCornerAllCorners radius:radius fillColor:[UIColor clearColor]];
}

- (UIImage *)cornerImageWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius{
    return [self cornerImageWithRoundingCorners:corners radius:radius fillColor:[UIColor clearColor]];
}
//radius等于0的时候并且为正方形的时候,直接裁剪为圆
- (UIImage *)cornerImageWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius fillColor:(UIColor *)fillColor{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    //填充颜色
    CGContextFillRect(context, rect);
    //利用贝塞尔曲线裁剪矩形
    if (radius != 0) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        [path addClip];
    }
    //绘制图像
    [self drawInRect:rect];
    //获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)resizableImageCenterMode{
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height / 2, self.size.width / 2, self.size.height / 2, self.size.width / 2)];
}
- (UIImage *)resizableImageCenterWithInset:(UIEdgeInsets)inset{
    CGFloat x = (self.size.width - inset.left - inset.right) / 2;
    CGFloat y = (self.size.height - inset.top - inset.bottom) / 2;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(y + inset.top, x + inset.left, y + inset.bottom, x + inset.right)];
}


@end

@implementation UIImage (Resize)
- (UIImage *)imageInset:(UIEdgeInsets)insets{
    if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
        return self;
    }
    CGRect imageRect =  CGRectMake(insets.left, insets.top, self.size.width, self.size.height);
    CGSize newSize = CGSizeZero;
    newSize.height = imageRect.size.height + (insets.top + insets.bottom);
    newSize.width  = imageRect.size.width + (insets.left + insets.right);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    //绘制图像
    [self drawInRect:imageRect];
    //获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)resizeImage:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(ctx, rect);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)resizeImageWithMaxValue:(CGFloat)max{
    CGFloat currentMax = MAX(self.size.width, self.size.height);
    if (max > currentMax) return self;
    CGFloat ratio = self.aspectRatio;
    if (ratio > 1){
        return [self resizeImage:CGSizeMake(max, max/ratio)];
    }else{
        return [self resizeImage:CGSizeMake(max/ratio, max)];
    }
}
@end

CGRect CGSize2CGRect(CGSize size){
    return CGRectMake(0, 0, size.width, size.height);
}
