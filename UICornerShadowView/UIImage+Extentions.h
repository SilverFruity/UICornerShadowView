//
//  UIImage+imageExtention.h
//  SharedGym
//
//  Created by Jiang on 2017/4/18.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, UIShadowPostion) {
    UIShadowPostionTop     = 1 << 0,
    UIShadowPostionRight    = 1 << 1,
    UIShadowPostionBottom  = 1 << 2,
    UIShadowPostionLeft = 1 << 3,
    UIShadowPostionAll  = ~0UL
};

typedef NS_OPTIONS(NSUInteger, UIBorderPostion) {
    UIBorderPostionTop     = 1 << 0,
    UIBorderPostionRight    = 1 << 1,
    UIBorderPostionBottom  = 1 << 2,
    UIBorderPostionLeft = 1 << 3,
    UIBorderPostionAll  = ~0UL
};


extern UIImage* UIImageWithColor(UIColor * _Nullable color);
extern UIImage* UIImageWithName( NSString * _Nullable name);

@interface UIImage (Property)
///宽高比
@property (nonatomic,assign,readonly)CGFloat aspectRatio;
@end

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
//使用mask重新渲染图片颜色
- (UIImage *)imageRenderWithColor:(UIColor *)color;

+ (UIImage *)gradientImage:(BOOL)isHorizontal
                startColor:(UIColor *)startColor
                  endColor:(UIColor *)endColor;

//线性渐变图片
+ (UIImage *)linearGradientImage:(CGSize)size
                    isHorizontal:(BOOL)isHorizontal
                       locations:(NSArray <NSNumber *>*)locations
                      startColor:(UIColor *)startColor
                        endColor:(UIColor *)endColor;
+ (UIImage *)centerResizeCircleImage:(UIColor *)color width:(CGFloat)width;
@end

@interface UIImage (Radius)
///圆形图片
- (UIImage *)circleImage;
///添加圆角
- (UIImage *)cornerImageWithCornerRadius:(CGFloat)radius;
- (UIImage *)cornerImageWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (UIImage *)cornerImageWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius fillColor:(UIColor *)fillColor;

+ (CGPoint)borderConvasOriginWithWidth:(CGFloat)width
                              position:(UIBorderPostion)position;

+ (CGSize)borderConvasSizeWithViewSize:(CGSize)viewSize
                                 width:(CGFloat)width
                              position:(UIBorderPostion)position;

+ (CGRect)borderConvasRectWithSize:(CGSize)viewSize
                             width:(CGFloat)width
                          position:(UIBorderPostion)position;

///添加边框
- (UIImage *)borderPathImageWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius width:(CGFloat)width position:(UIBorderPostion)position strokeColor:(nullable UIColor *)strokeColor;
- (UIImage *)borderPathImageWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius width:(CGFloat)width  position:(UIBorderPostion)position strokeColor:(nullable UIColor *)strokeColor fillColor:(UIColor *)fillColor;

+ (CGPoint)shadowBackGroundImageOriginWithShadowOffset:(CGSize)shadowOffset
                                          shadowRadius:(CGFloat)shadowRadius
                                              position:(UIShadowPostion)position;

+ (CGSize)shadowBackGroundImageSizeWithViewSize:(CGSize)viewSize
                                   shadowOffset:(CGSize)shadowOffset
                                   shadowRadius:(CGFloat)shadowRadius
                                       position:(UIShadowPostion)position;

+ (CGRect)shadowBackGroundImageRectWithViewSize:(CGSize)viewSize
                                   shadowOffset:(CGSize)shadowOffset
                                   shadowRadius:(CGFloat)shadowRadius
                                       position:(UIShadowPostion)position;

- (UIImage *)shadow:(CGSize)offest radius:(CGFloat)radius color:(UIColor *)color shadowPositoin:(UIShadowPostion)position;
- (UIImage *)shadow:(CGSize)offest radius:(CGFloat)radius color:(UIColor *)color;
///设置中点为拉伸区域
- (UIImage *)resizableImageCenterMode;
///获取正中心的正方形
- (UIImage *)centerRectWithAspectRatio:(CGFloat)aspectRatio;
- (UIImage *)centerSquare;
@end
@interface UIImage (Resize)
- (UIImage *)imageInset:(UIEdgeInsets)insets;
- (UIImage *)resizeImage:(CGSize)size;
- (UIImage *)resizeImageWithMaxValue:(CGFloat)max;
@end


NS_ASSUME_NONNULL_END
