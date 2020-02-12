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
CGRect CGSize2CGRect(CGSize size){
    return CGRectMake(0, 0, size.width, size.height);
}
CGSize CGContextGetSize(CGContextRef ctx){
    return CGSizeMake(CGBitmapContextGetWidth(ctx) / SCREEN_SCALE, CGBitmapContextGetHeight(ctx) / SCREEN_SCALE);
}
CGRect CGContextGetBound(CGContextRef ctx){
    return CGSize2CGRect(CGContextGetSize(ctx));
}
@implementation SFColorImage
+ (instancetype)imageWithColor:(UIColor *)color{
    SFColorImage *colorImage = [[self class] new];
    colorImage.color = color;
    colorImage.size = CGSizeMake(1, 1);
    return colorImage;
}
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size{
    SFColorImage *colorImage = [self imageWithColor:color];
    colorImage.size = size;
    return colorImage;
}
- (CGContextRef)begin{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    return UIGraphicsGetCurrentContext();
}
- (void)process:(CGContextRef)ctx{
    CGRect rect = CGContextGetBound(ctx);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextSetAlpha(ctx, CGColorGetAlpha(self.color.CGColor));
    CGContextFillRect(ctx, rect);
}

@end
@implementation SFGradientImage
+ (instancetype)isHorizontal:(BOOL)isHorizontal startColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    SFGradientImage *gradient = [[self class] new];
    gradient.isHorizontal = isHorizontal;
    gradient.colors = @[startColor, endColor];
    gradient.locations = @[@(0),@(1)];
    gradient.size = isHorizontal ? CGSizeMake(SCREEN_WIDTH, 1) : CGSizeMake(1, SCREEN_HEIGHT);
    return gradient;
}
- (CGContextRef)begin{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    return UIGraphicsGetCurrentContext();
}
- (void)process:(CGContextRef)ctx{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat cLocations[2];
    cLocations[0] = self.locations.firstObject.doubleValue;
    cLocations[1] = self.locations.lastObject.doubleValue;
    
    NSMutableArray *colors = [NSMutableArray array];
    for (UIColor *color in self.colors) {
        [colors addObject:(__bridge id)color.CGColor];
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, cLocations);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGContextGetBound(ctx)];
    CGRect pathRect = CGPathGetBoundingBox(path.CGPath);;
    
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(pathRect) * cLocations[0], CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect) * cLocations[1], CGRectGetMidY(pathRect));
    if (!self.isHorizontal) {
        startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect) * cLocations[0]);
        endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect) * cLocations[1]);
    }
    CGContextSaveGState(ctx);
    [path addClip];
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end

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
- (void)process:(CGContextRef)ctx{
    if (!self.isEnable) return;
    CGRect rect = CGContextGetBound(ctx);
    [self.fillColor setFill];
    CGContextFillRect(ctx, rect);
    //利用贝塞尔曲线裁剪矩形
    if (self.radius != 0) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:self.position cornerRadii:CGSizeMake(self.radius, self.radius)];
        [path addClip];
    }
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
- (void)process:(CGContextRef)ctx{
    if (!self.isEnable) return;
    UIImage *target = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIEdgeInsets insets = [self convasEdgeInsets];
    CGSize canvasSize = [self convasSizeWithSize:target.size];
    CGRect canvasRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    UIGraphicsBeginImageContextWithOptions(canvasRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.fillColor setFill];
    CGContextFillRect(context,canvasRect);
    CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlurRadius, self.shadowColor.CGColor);
    [target drawInRect:CGRectMake(insets.left, insets.top, target.size.width, target.size.height)];

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
- (void)process:(CGContextRef)ctx rectCorner:(SFRectCorner *)rectCorner{
    if (!self.isEnable) return;
    CGRect rect = CGContextGetBound(ctx);
    [self.color setStroke];
    [self.fillColor setFill];
    CGContextFillRect(ctx, rect);
    if (rectCorner){
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner.position cornerRadii:CGSizeMake(rectCorner.radius, rectCorner.radius)];
        [clipPath addClip];
    }
    
    CGRect strokeRect = CGContextGetClipBoundingBox(ctx);
    strokeRect = [self strokeRectWithSize:rect.size];
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
    
}
@end

@implementation UIImage (Property)
- (CGFloat)aspectRatio{
    return self.size.width / self.size.height;
}
@end
@implementation UIImage (Color)
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
    SFRectCorner *rectCorner = [SFRectCorner new];
    rectCorner.fillColor = [UIColor clearColor];
    rectCorner.position = UIRectCornerAllCorners;
    rectCorner.radius = image.size.width * 0.5;
    return [UIImage new];
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
