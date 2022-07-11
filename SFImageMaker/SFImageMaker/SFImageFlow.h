//
//  SFImageManager.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFImageMaker-Protocol.h"
#import "SFBlurImageMaker.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFImageFlow : NSObject
@property (nonatomic, nullable, strong)UIImage *targetImage;
@property (nonatomic, nullable, strong)id <SFImageGenerator> generator;
@property (nonatomic, nullable, strong)NSMutableArray *processors;
@property (nonatomic, nullable, strong)NSMutableArray *finals;
+ (instancetype)flow;
+ (instancetype)flowWithImage:(UIImage *)targetImage;
+ (instancetype)flowWithGenerator:(id <SFImageGenerator>)generator;
- (void)appendProcessor:(id)processor;
- (void)saveContext;
- (UIImage *)image;
- (NSString *)identifier;
@end
NS_ASSUME_NONNULL_END

#import <SFImageMaker/SFBorderImageMaker.h>
NS_ASSUME_NONNULL_BEGIN
@interface SFImageFlow (Processor)
@property (nonatomic, readonly)SFImageFlow* (^corner)(CGFloat radius, UIRectCorner rectCorner);
@property (nonatomic, readonly)SFImageFlow* (^border)(CGFloat width, UIColor *color);
@property (nonatomic, readonly)SFImageFlow* (^borderWithPosition)(UIBorderPostion position, CGFloat width, UIColor *color);
@property (nonatomic, readonly)SFImageFlow* (^shadow)(UIColor *color, CGSize offset, CGFloat blurRadius);
@property (nonatomic, readonly)SFImageFlow* (^blur)(SFBlurEffect effect);;
@property (nonatomic, readonly)SFImageFlow* (^centerRect)(CGFloat aspectRatio);
@property (nonatomic, readonly)SFImageFlow* (^edgeInsets)(UIEdgeInsets insets, UIColor *fillColor);
@property (nonatomic, readonly)SFImageFlow* (^resize)(CGSize size);
@property (nonatomic, readonly)SFImageFlow* (^resizeWithMax)(CGFloat max);
@end


@interface SFImageFlow (SwiftProcessor)
- (SFImageFlow *)cornerWithRadius:(CGFloat)radius rectCorner: (UIRectCorner) rectCorner;
- (SFImageFlow *)borderWithWidth:(CGFloat)width color:(UIColor *)color;
- (SFImageFlow *)borderWithPosition:(UIBorderPostion)position width:(CGFloat)width color:(UIColor *)color;
- (SFImageFlow *)shadowWithColor:(UIColor *)color offset:(CGSize)offset blurRadius:(CGFloat) blurRadius;
- (SFImageFlow *)blurWithEffect:(SFBlurEffect)effect;
- (SFImageFlow *)centerRectWithAspectRatio:(CGFloat)aspectRatio;
- (SFImageFlow *)edgeInsetsWithInsets:(UIEdgeInsets)insets fillColor:(UIColor *)fillColor;
- (SFImageFlow *)resizeWithSize:(CGSize)size;
- (SFImageFlow *)resizeWithMax:(CGFloat)max;
@property (nonatomic, readonly)SFImageFlow* circle;
@property (nonatomic, readonly)SFImageFlow* centerSquare;
@end
NS_ASSUME_NONNULL_END
