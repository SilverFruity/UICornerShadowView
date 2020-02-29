//
//  UIImage+imageExtention.h
//  SharedGym
//
//  Created by Jiang on 2017/4/18.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIImage (Radius)
///设置中点为拉伸区域
- (UIImage *)resizableImageCenterMode;
- (UIImage *)resizableImageCenterWithInset:(UIEdgeInsets)inset;
@end


NS_ASSUME_NONNULL_END
