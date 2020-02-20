//
//  SFShadowImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, UIShadowPostion) {
    UIShadowPostionTop    = 1 << 0,
    UIShadowPostionRight  = 1 << 1,
    UIShadowPostionBottom = 1 << 2,
    UIShadowPostionLeft   = 1 << 3,
    UIShadowPostionAll    = ~0UL
};

@interface SFShadowImageMaker : NSObject
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

NS_ASSUME_NONNULL_END
