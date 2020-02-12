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

@interface SFRectCorner: NSObject
@property (nonatomic, assign)CGFloat radius;
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, assign)UIRectCorner position;
@property (nonatomic, getter=isEnable)BOOL enable;
- (UIImage *)process:(UIImage *)target;
@end

@interface SFShadow: NSObject
@property (nonatomic, assign)CGSize shadowOffset;
@property (nonatomic, assign)CGFloat shadowBlurRadius;
@property (nonatomic, strong)UIColor *shadowColor;
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, assign)UIShadowPostion position;
@property (nonatomic, getter=isEnable)BOOL enable;
- (CGRect)viewRectForSize:(CGSize)size;
- (UIEdgeInsets)convasEdgeInsets;
- (UIImage *)process:(UIImage *)target;
@end
    
@interface SFBorder: NSObject
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, assign)UIBorderPostion position;
@property (nonatomic, getter=isEnable)BOOL enable;
- (CGRect)strokeRectWithSize:(CGSize)size;
- (UIImage *)process:(UIImage *)target rectCorner:(SFRectCorner *)rectCorner;
@end

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
///设置中点为拉伸区域
- (UIImage *)resizableImageCenterMode;
- (UIImage *)resizableImageCenterWithInset:(UIEdgeInsets)inset;
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
