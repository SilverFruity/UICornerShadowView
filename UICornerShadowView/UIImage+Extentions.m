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
- (UIImage *)borderPathImageWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius width:(CGFloat)width strokeColor:(nullable UIColor *)strokeColor{
    return [self borderPathImageWithRoundingCorners:corners radius:radius width:width strokeColor:strokeColor fillColor:[UIColor clearColor]];
}
- (UIImage *)borderPathImageWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius width:(CGFloat)width strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor{
    if (radius == 0 || strokeColor == nil){
        return self;
    }
    CGRect strokeRect = CGRectMake(width/2, width/2, self.size.width-width, self.size.height-width);
    CGRect rect = CGSize2CGRect(self.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    [strokeColor setStroke];
    //填充颜色
    CGContextFillRect(context, rect);
    [self drawInRect:rect];
    if (width > radius){ // 当 width 40 radius 20的情况下
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        [clipPath addClip];
    }
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    if (width > radius){ // 当 width 40 radius 20的情况下
        linePath = [UIBezierPath bezierPathWithRect:strokeRect];
    }
    linePath.lineWidth = width;
    linePath.lineCapStyle = kCGLineCapRound;
    linePath.lineJoinStyle = kCGLineJoinRound;
    [linePath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (CGPoint)shadowBackGroundImageOriginWithShadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius position:(UIShadowPostion)position{
    CGFloat viewX = (shadowOffset.width > 0 ? 0 : shadowOffset.width) + (position&UIShadowPostionLeft ? -shadowRadius : 0);
    CGFloat viewY = (shadowOffset.height > 0 ? 0 : shadowOffset.height) + (position&UIShadowPostionTop ? -shadowRadius : 0);
    return CGPointMake(viewX, viewY);
}
+ (CGSize)shadowBackGroundImageSizeWithViewSize:(CGSize)viewSize shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius position:(UIShadowPostion)position{
    CGFloat offsetWidth = 0;
    CGFloat offsetHeight = 0;
    if (position&UIShadowPostionRight&&shadowOffset.width>0) {
        offsetWidth = fabs(shadowOffset.height);
    }else if (position&UIShadowPostionLeft&&shadowOffset.width<0) {
        offsetWidth = fabs(shadowOffset.height);
    }
    if (position&UIShadowPostionBottom&&shadowOffset.height>0) {
        offsetHeight = fabs(shadowOffset.height);
    }else if (position&UIShadowPostionTop&&shadowOffset.height<0) {
        offsetHeight = fabs(shadowOffset.height);
    }
    CGFloat canvasWidth = viewSize.width + offsetWidth;
    CGFloat canvasHeight = viewSize.height + offsetHeight;
    canvasHeight += position&UIShadowPostionTop?shadowRadius:0;
    canvasHeight += position&UIShadowPostionBottom?shadowRadius:0;
    canvasWidth  += position&UIShadowPostionLeft?shadowRadius:0;
    canvasWidth  += position&UIShadowPostionRight?shadowRadius:0;
    return CGSizeMake(canvasWidth, canvasHeight);
}
+ (CGRect)shadowBackGroundImageRectWithViewSize:(CGSize)viewSize
                                   shadowOffset:(CGSize)shadowOffset
                                   shadowRadius:(CGFloat)shadowRadius
                                       position:(UIShadowPostion)position{
    CGPoint origin = [self shadowBackGroundImageOriginWithShadowOffset:shadowOffset shadowRadius:shadowRadius position:position];
    CGSize size = [self shadowBackGroundImageSizeWithViewSize:viewSize shadowOffset:shadowOffset shadowRadius:shadowRadius position:position];
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (UIImage *)shadow:(CGSize)offest radius:(CGFloat)radius color:(UIColor *)color shadowPositoin:(UIShadowPostion)position{
    CGSize radiusOffset = CGSizeMake(radius, radius);
    CGSize canvasSize = [[self class] shadowBackGroundImageSizeWithViewSize:self.size shadowOffset:offest shadowRadius:radius position:position];
    CGRect canvasRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    UIGraphicsBeginImageContextWithOptions(canvasRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColor.clearColor.CGColor);
    CGContextSetShadowWithColor(context, offest, radius, color.CGColor);
    [self drawInRect:CGRectMake((offest.width > 0 ? 0 : fabs(offest.width)) + (position&UIShadowPostionLeft?radiusOffset.width:0), (offest.height > 0 ? 0 : fabs(offest.height)) + (position&UIShadowPostionTop?radiusOffset.height:0), self.size.width, self.size.height)];

    //获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)shadow:(CGSize)offest radius:(CGFloat)radius color:(UIColor *)color{
    return [self shadow:offest radius:radius color:color shadowPositoin:UIShadowPostionAll];
    
}
- (UIImage *)resizableImageCenterMode{
     return [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height / 2, self.size.width / 2, self.size.height / 2, self.size.width / 2)];
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
