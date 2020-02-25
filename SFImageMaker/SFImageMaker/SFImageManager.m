//
//  SFImageManager.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFImageManager.h"

@implementation SFImageManager
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static SFImageManager *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [SFImageManager new];
    });
    return _instance;
}
- (UIImage *)startWithGenerator:(id<SFImageGenerator>)generator processors:(NSArray<id<SFImageProcessor>> *)processors{
    UIImage *image = generator.generate;
    return [self startWithImage:image processors:processors];
}
- (UIImage *)startWithImage:(UIImage *)image processors:(NSArray <id <SFImageProcessor>>*)processors{
    for (id <SFImageProcessor> processor in processors){
        image = [processor process:image];
    }
    return image;
}
@end
