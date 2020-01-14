//
//  UIImage+imageExtention.m
//  SharedGym
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

+ (CGSize)shadowEdgeSizeWithSize:(CGSize)size offset:(CGSize)offset radius:(CGFloat)radius position:(UIShadowPostion)position{
    CGSize radiusOffset = CGSizeMake(radius, radius);
    CGFloat offsetWidth = 0;
    CGFloat offsetHeight = 0;
    if (position&UIShadowPostionRight&&offset.width>0) {
        offsetWidth = fabs(offset.height);
    }else if (position&UIShadowPostionLeft&&offset.width<0) {
        offsetWidth = fabs(offset.height);
    }
    if (position&UIShadowPostionBottom&&offset.height>0) {
        offsetHeight = fabs(offset.height);
    }else if (position&UIShadowPostionTop&&offset.height<0) {
        offsetHeight = fabs(offset.height);
    }
    CGFloat canvasWidth = size.width + offsetWidth;
    CGFloat canvasHeight = size.height + offsetHeight;
    canvasHeight += position&UIShadowPostionTop?radiusOffset.height:0;
    canvasHeight += position&UIShadowPostionBottom?radiusOffset.height:0;
    canvasWidth  += position&UIShadowPostionLeft?radiusOffset.width:0;
    canvasWidth  += position&UIShadowPostionRight?radiusOffset.width:0;
    return CGSizeMake(canvasWidth, canvasHeight);
}
- (UIImage *)shadow:(CGSize)offest radius:(CGFloat)radius color:(UIColor *)color shadowPositoin:(UIShadowPostion)position{
    CGSize radiusOffset = CGSizeMake(radius, radius);
    CGSize canvasSize = [[self class] shadowEdgeSizeWithSize:self.size offset:offest radius:radius position:position];
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

@implementation UIImage (Orientation)

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end



@implementation UIImage (QrCodeBarCode)

+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size color:(UIColor *)color{
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    UIImage *image = [self barcodeImageWithContent:content codeImageSize:size];
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    //遍历像素, 改变像素点颜色
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i<pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red*255;
            ptr[2] = green*255;
            ptr[1] = blue*255;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    //取出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpaceRef);
    
    return resultImage;
}

//改变条形码尺寸大小
+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size{
    CIImage *image = [self barcodeImageWithContent:content];
    CGRect integralRect = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(integralRect), size.height/CGRectGetHeight(integralRect));
    
    size_t width = CGRectGetWidth(integralRect)*scale;
    size_t height = CGRectGetHeight(integralRect)*scale;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:integralRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, integralRect, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//生成最原始的条形码
+ (CIImage *)barcodeImageWithContent:(NSString *)content{
    CIFilter *qrFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    [qrFilter setValue:@(0.00) forKey:@"inputQuietSpace"];
    CIImage *image = qrFilter.outputImage;
    return image;
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

@end


@implementation UIImage (Application)
+ (UIImage *)profileMemberShipCircle:(CGSize)size maxPoint:(CGFloat)max currentPoint:(CGFloat)current{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGFloat boldLineWidth = 4;
    [[UIColor blackColor] setFill];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGSize2CGRect(size), boldLineWidth/2, boldLineWidth/2)];
    circlePath.lineWidth = 1;
    [circlePath stroke];
    if (current > 0) {
        UIBezierPath *arcPath  =[UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width / 2, size.height / 2) radius:size.width / 2 - boldLineWidth/2 startAngle:-M_PI_2 endAngle:current/max * M_PI * 2 - M_PI_2 - 0.001 clockwise:YES];
        arcPath.lineWidth = boldLineWidth;
        arcPath.lineCapStyle = kCGLineCapRound;
        [arcPath stroke];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

CGRect CGSize2CGRect(CGSize size){
    return CGRectMake(0, 0, size.width, size.height);
}

UIImage* UIImageWithColor(UIColor *color){
    
    return [UIImage imageWithColor:color];
}
UIImage* UIImageWithName(NSString *name){
    return [UIImage imageNamed:name];
}
