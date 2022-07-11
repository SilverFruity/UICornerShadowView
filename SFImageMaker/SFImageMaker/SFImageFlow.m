//
//  SFImageManager.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFImageFlow.h"
static id visitProcessor(id processor,
                         id result,
                         id (^handler)(id, id<SFImageIdentifier, SFImageDependencies>)) {
    if (handler) {
        result = handler(result, processor);
    }
    id<SFImageIdentifier, SFImageDependencies> cur = processor;
    for (id<SFImageProcessor> subProcessor in cur.dependencies) {
        result = visitProcessor(subProcessor, result, handler);
    }
    return result;
}

static id visitProcessors(NSArray *processors,
                          id result,
                          id (^handler)(id result, id curProcessor)) {
    for (id<SFImageIdentifier, SFImageProcessor> processor in processors) {
        result = visitProcessor(processor, result, handler);
    }
    return result;
}

NSString *sf_identifierWithProcessors(NSArray *processors) {
    return visitProcessors(processors, [@"" mutableCopy], ^id(id result, id<SFImageIdentifier, SFImageDependencies> curProcessor) {
        return [NSString stringWithFormat:@"%@%@", result, curProcessor.identifier];
    });
}

@implementation SFImageFlow
+ (instancetype)flow{
    return [SFImageFlow new];
}
+ (instancetype)flowWithImage:(UIImage *)targetImage{
    SFImageFlow *proc = [SFImageFlow new];
    proc.targetImage = targetImage;
    return proc;
}
+ (instancetype)flowWithGenerator:(id <SFImageGenerator>)generator{
    SFImageFlow *proc = [SFImageFlow new];
    proc.generator = generator;
    return proc;
}
- (instancetype)init
{
    self = [super init];
    self.processors = [NSMutableArray array];
    self.finals = [NSMutableArray array];
    return self;
}
- (void)appendProcessor:(id)processor{
    [self.processors addObject:processor];
}
- (UIImage *)image{
    UIImage *result = nil;
    if (self.generator) {
        result = [self startWithGenerator:self.generator processors:self.processors];
    }else{
        result = [self startWithImage:self.targetImage processors:self.processors];
    }
    result = [self startWithImage:result processors:self.finals];
    return result;
}

- (NSString *)identifier {
    NSString *result = nil;
    if (self.generator) {
        NSMutableArray *procssors = [@[ self.generator ] mutableCopy];
        [procssors addObjectsFromArray:self.processors];
        result = sf_identifierWithProcessors(procssors);
    } else {
        result = sf_identifierWithProcessors(self.processors);
    }
    return [result stringByAppendingString:sf_identifierWithProcessors(self.finals)];
}

- (UIImage *)startWithGenerator:(id<SFImageGenerator>)generator processors:(NSArray<id<SFImageProcessor>> *)processors{
    UIImage *image = [generator generate];
    image = [self startWithImage:image processors:(id)generator.dependencies];
    return [self startWithImage:image processors:processors];
}

- (UIImage *)startWithImage:(UIImage *)image processors:(NSArray<id<SFImageProcessor>> *)processors {
    return visitProcessors(processors, image, ^id(id result, id curProcessor) {
        return [curProcessor process:result];
    });
}

- (void)saveContext {
    NSMutableArray *processors = [@[ self.generator ] mutableCopy];
    [processors addObjectsFromArray:self.processors];
    visitProcessors(processors, nil, ^id(id result, id curProcessor) {
        if ([curProcessor respondsToSelector:@selector(saveContext)]) {
            [curProcessor saveContext];
        }
        return nil;
    });
}
@end

#import "SFImageMaker.h"

@implementation SFImageFlow (Processor)
- (SFImageFlow * _Nonnull (^)(CGFloat, UIRectCorner))corner{
    return  ^SFImageFlow* (CGFloat radius, UIRectCorner rectCorner){
        return [self cornerWithRadius:radius rectCorner:rectCorner];
    };
}
- (SFImageFlow * _Nonnull (^)(CGFloat, UIColor * _Nonnull))border{
    return  ^SFImageFlow* (CGFloat width, UIColor *color){
        return [self borderWithWidth:width color:color];
    };
}
- (SFImageFlow * _Nonnull (^)(UIBorderPostion, CGFloat, UIColor * _Nonnull))borderWithPosition{
    return  ^SFImageFlow* (UIBorderPostion position, CGFloat width, UIColor *color){
        return [self borderWithPosition:position width:width color:color];
    };
}

- (SFImageFlow * _Nonnull (^)(UIColor * _Nonnull, CGSize, CGFloat))shadow{
    return  ^SFImageFlow* (UIColor *color, CGSize offset, CGFloat blurRadius){
        return [self shadowWithColor:color offset:offset blurRadius:blurRadius];
    };
}
- (SFImageFlow * _Nonnull (^)(SFBlurEffect))blur{
    return  ^SFImageFlow* (SFBlurEffect effect){
        return [self blurWithEffect:effect];
    };
}
- (SFImageFlow * _Nonnull (^)(CGFloat))centerRect{
    return  ^SFImageFlow* (CGFloat aspectRatio){
        return [self centerRectWithAspectRatio:aspectRatio];
    };
}
- (SFImageFlow * _Nonnull (^)(UIEdgeInsets, UIColor * _Nonnull))edgeInsets{
    return  ^SFImageFlow* (UIEdgeInsets insets, UIColor *fillColor){
        return [self edgeInsetsWithInsets:insets fillColor:fillColor];
    };
}
- (SFImageFlow * _Nonnull (^)(CGSize))resize{
    return  ^SFImageFlow* (CGSize size){
        return [self resizeWithSize:size];
    };
}
- (SFImageFlow * _Nonnull (^)(CGFloat))resizeWithMax{
    return  ^SFImageFlow* (CGFloat max){
        return [self resizeWithMax:max];
    };
}
@end



@implementation SFImageFlow (SwiftProcessor)
- (SFImageFlow *)cornerWithRadius:(CGFloat)radius rectCorner: (UIRectCorner) rectCorner{
    SFCornerImageMaker *maker = [SFCornerImageMaker new];
    maker.radius = radius;
    maker.position = rectCorner;
    if ([self.generator conformsToProtocol:@protocol(SFImageGenerator)]) {
        SFColorImageMaker *generator = (SFColorImageMaker *)self.generator;
        CGSize size = generator.size;
        if (size.height < radius * 2) size.height = radius * 2;
        if (size.width < radius * 2) size.width = radius * 2;
        if (!CGSizeEqualToSize(generator.size, size)) {
            generator.size = size;
            [self.finals addObject:[SFBlockImageMaker resizableCenterMode]];
        }
    }
    [self appendProcessor:maker];
    return self;
}
- (SFImageFlow *)borderWithWidth:(CGFloat)width color:(UIColor *)color{
    return [self borderWithPosition:UIBorderPostionAll width:width color:color];
}
- (SFImageFlow *)borderWithPosition:(UIBorderPostion)position width:(CGFloat)width color:(UIColor *)color{
    SFBorderImageMaker *maker = [SFBorderImageMaker new];
    maker.width = width;
    maker.position = position;
    maker.color = color;
    for (id processor in self.processors) {
        if ([processor isKindOfClass:[SFCornerImageMaker class]]) {
            maker.cornerMaker = processor;
            break;
        }
    }
    [self appendProcessor:maker];
    return self;
}
- (SFImageFlow *)shadowWithColor:(UIColor *)color offset:(CGSize)offset blurRadius:(CGFloat) blurRadius{
    SFShadowImageMaker *maker = [SFShadowImageMaker new];
    maker.shadowColor = color;
    maker.shadowOffset = offset;
    maker.shadowBlurRadius = blurRadius;
    maker.position = UIShadowPostionAll;
    [self appendProcessor:maker];
    return self;
}
- (SFImageFlow *)blurWithEffect:(SFBlurEffect)effect{
    switch (effect) {
        case SFBlurEffectLight:
            [self appendProcessor:[SFBlurImageMaker lightEffect]];
            break;
        case SFBlurEffectDark:
            [self appendProcessor:[SFBlurImageMaker darkEffect]];
            break;
        case SFBlurEffectExtraLight:
            [self appendProcessor:[SFBlurImageMaker extraLightEffect]];
            break;
    }
    return self;
}
- (SFImageFlow *)centerRectWithAspectRatio:(CGFloat)aspectRatio{
    [self appendProcessor:[SFBlockImageMaker centerRectWithAspectRatio:aspectRatio]];
    return self;
}
- (SFImageFlow *)edgeInsetsWithInsets:(UIEdgeInsets)insets fillColor:(UIColor *)fillColor{
    [self appendProcessor:[SFBlockImageMaker edgeInsets:insets fillColor:fillColor]];
    return self;
}
- (SFImageFlow *)resizeWithSize:(CGSize)size{
    [self appendProcessor:[SFBlockImageMaker resizeWithSize:size]];
    return self;
}
- (SFImageFlow *)resizeWithMax:(CGFloat)max{
    [self appendProcessor:[SFBlockImageMaker resizeWithMaxValue:max]];
    return self;
}
- (SFImageFlow *)circle{
    [self appendProcessor:[SFCircleImageMaker new]];
    return self;
}
- (SFImageFlow *)centerSquare{
    [self appendProcessor:[SFBlockImageMaker centerSquare]];
    return self;
}
@end
