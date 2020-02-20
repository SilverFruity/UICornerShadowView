//
//  SFGradientImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFGradientImageMaker : NSObject
@property (nonatomic, assign)BOOL isHorizontal;
@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)NSArray<NSNumber *> *locations;
@property (nonatomic, copy)NSArray<UIColor *> *colors;
+ (instancetype)isHorizontal:(BOOL)isHorizontal startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (UIImage *)general;
@end

NS_ASSUME_NONNULL_END
