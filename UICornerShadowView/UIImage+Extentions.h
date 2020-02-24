//
//  UIImage+imageExtention.h
//  SharedGym
//
//  Created by Jiang on 2017/4/18.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

extern UIImage* UIImageWithColor(UIColor * _Nullable color);
extern UIImage* UIImageWithName( NSString * _Nullable name);

@interface UIImage (Property)
///宽高比
@property (nonatomic,assign,readonly)CGFloat aspectRatio;
@end

@interface UIImage (Color)
//使用mask重新渲染图片颜色
- (UIImage *)imageRenderWithColor:(UIColor *)color;
@end

@interface UIImage (Radius)
///获取正中心的正方形
- (UIImage *)centerRectWithAspectRatio:(CGFloat)aspectRatio;
- (UIImage *)centerSquare;
///圆形图片
- (UIImage *)circleImage;

///设置中点为拉伸区域
- (UIImage *)resizableImageCenterMode;
- (UIImage *)resizableImageCenterWithInset:(UIEdgeInsets)inset;
@end


NS_ASSUME_NONNULL_END
