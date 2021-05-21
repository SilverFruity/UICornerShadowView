//
//  SFImageManager.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFImageFlow.h"
void sf_recursiveGetIdentifier(NSMutableString *identifier,id <SFImageIdentifier,SFImageDependencies> processor){
    [identifier appendString:processor.identifier];
    for (id <SFImageProcessor> subProcessor in processor.dependencies) {
        sf_recursiveGetIdentifier(identifier, subProcessor);
    }
}
NSString *sf_identifierWithProcessors(NSArray *processors){
    NSMutableString * identifier = [@"" mutableCopy];
    for (id<SFImageIdentifier,SFImageProcessor> processor in processors){
        sf_recursiveGetIdentifier(identifier, processor);
    }
    return [identifier copy];
}
NSString *sf_identifierWithGenerator(id generator, NSArray *processors){
    NSMutableArray *elements = [@[generator] mutableCopy];
    if (processors){
        [elements addObjectsFromArray:processors];
    }
    return sf_identifierWithProcessors([elements copy]);
}

@implementation SFImageFlow
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
    return self;
}
- (void)appendProcessor:(id)processor{
    self.lastProcessor = processor;
    [self.processors addObject:processor];
}
- (UIImage *)image{
    if (self.generator) {
        return [self startWithGenerator:self.generator processors:self.processors];
    }else{
       return [self startWithImage:self.targetImage processors:self.processors];
    }
}
- (NSString *)identifier{
    if (self.generator) {
        return sf_identifierWithGenerator(self.generator, self.processors);
    }else{
        return sf_identifierWithProcessors(self.processors);
    }
}
- (UIImage *)startWithGenerator:(id<SFImageGenerator>)generator processors:(NSArray<id<SFImageProcessor>> *)processors{
    UIImage *image = [generator generate];
    NSMutableArray *totalProcessors = [generator.dependencies mutableCopy];
    if (processors) {
        [totalProcessors addObjectsFromArray:processors];
    }
    return [self startWithImage:image processors:totalProcessors];
}
- (UIImage *)startWithImage:(UIImage *)image processors:(NSArray <id <SFImageProcessor>>*)processors{
    for (id <SFImageProcessor> processor in processors){
        image = [self recursiveProcess:image processor:processor];
    }
    return image;
}
- (UIImage *)recursiveProcess:(UIImage *)image processor:(id <SFImageProcessor>)processor{
    image = [processor process:image];
    for (id <SFImageProcessor> subProcessor in processor.dependencies) {
        image = [self recursiveProcess:image processor:subProcessor];
    }
    return image;
}
@end

#import "SFImageMaker.h"

@implementation SFImageFlow (Processor)
- (SFImageFlow * _Nonnull (^)(CGFloat, UIRectCorner))corner{
    return  ^SFImageFlow* (CGFloat radius, UIRectCorner rectCorner){
        SFCornerImageMaker *maker = [SFCornerImageMaker new];
        maker.radius = radius;
        maker.position = rectCorner;
        [self appendProcessor:maker];
        return self;
    };
}
- (SFImageFlow * _Nonnull (^)(CGFloat, UIColor * _Nonnull))border{
    return  ^SFImageFlow* (CGFloat width, UIColor *color){
        return self.borderWithPosition(UIBorderPostionAll, width, color);
    };
}
- (SFImageFlow * _Nonnull (^)(UIBorderPostion, CGFloat, UIColor * _Nonnull))borderWithPosition{
    return  ^SFImageFlow* (UIBorderPostion position, CGFloat width, UIColor *color){
        SFBorderImageMaker *maker = [SFBorderImageMaker new];
        maker.width = width;
        maker.position = position;
        maker.color = color;
        if ([self.lastProcessor isKindOfClass:[SFCornerImageMaker class]]) {
            maker.cornerMaker = self.lastProcessor;
        }
        [self appendProcessor:maker];
        return self;
    };
}

- (SFImageFlow * _Nonnull (^)(UIColor * _Nonnull, CGSize, CGFloat))shadow{
    return  ^SFImageFlow* (UIColor *color, CGSize offset, CGFloat blurRadius){
        SFShadowImageMaker *maker = [SFShadowImageMaker new];
        maker.shadowColor = color;
        maker.shadowOffset = offset;
        maker.shadowBlurRadius = blurRadius;
        maker.position = UIShadowPostionAll;
        [self appendProcessor:maker];
        return self;
    };
}
@end
