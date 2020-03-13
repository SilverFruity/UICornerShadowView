//
//  SFImageManager.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFImageMakerManager.h"

@implementation SFImageMakerManager
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static SFImageMakerManager *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [SFImageMakerManager new];
    });
    return _instance;
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

- (NSString *)identifierWithGenerator:(id<SFImageGenerator>)generator processors:(NSArray<id<SFImageProcessor>> *)processors{
    NSMutableArray *elements = [@[generator] mutableCopy];
    if (processors){
        [elements addObjectsFromArray:processors];
    }
    return [self identifierWithProcessors:[elements copy]];
}
- (NSString *)identifierWithProcessors:(NSArray<id<SFImageIdentifier,SFImageProcessor>> *)processors{
    NSMutableString * identifier = [@"" mutableCopy];
    for (id<SFImageIdentifier,SFImageProcessor> processor in processors){
        [self recursiveGetIdentifier:identifier processor:processor];
    }
    return [identifier copy];
}

- (void)recursiveGetIdentifier:(NSMutableString *)identifier processor:(id <SFImageIdentifier,SFImageDependencies>)processor{
    [identifier appendString:processor.identifier];
    for (id <SFImageProcessor> subProcessor in processor.dependencies) {
        [self recursiveGetIdentifier:identifier processor:subProcessor];
    }
}
@end
