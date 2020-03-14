//
//  SFWebImageProcessor.m
//  SFImageMaker
//
//  Created by Jiang on 2020/3/13.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFWebImageMakerHelper.h"
#import "SFImageMakerManager.h"
@interface SFWebImageMakerHelper()
@property (nonatomic, copy)NSArray<id<SFImageProcessor>> *processors;
@property (nonatomic, readwrite, strong)NSURL *url;
@end
@implementation SFWebImageMakerHelper
- (instancetype)initWithUrl:(NSURL *)url processors:(NSArray<id<SFImageProcessor>> *)processors{
    self = [super init];
    self.url = url;
    self.processors = processors;
    return self;
}
- (NSString *)identifier{
    return [SFImageMakerManager.shared identifierWithProcessors:self.processors];
}
- (void)prcoessWithCompleted:(SFWebImageCompleteHandler)completed{
    if (!self.delegate || !self.url){
        return;
    }
    NSString *identifier = self.identifier;
    void (^noCacheOperation)(void) = ^{
        [self.delegate downloadForUrl:self.url completed:^(UIImage * _Nullable downloadImage, NSURL * _Nullable url, NSError * _Nullable error) {
            if (downloadImage){
                UIImage *resultImage = [SFImageMakerManager.shared startWithImage:downloadImage processors:self.processors];
                // save without identifier
                NSString *noIdentifierKey = [self.delegate keyForUrl:self.url identifier:nil];
                [self.delegate saveMemeryCache:downloadImage forKey:noIdentifierKey];
                [self.delegate saveDiskCache:downloadImage forKey:noIdentifierKey completed:nil];
                
                // save with identifier
                NSString *key = [self.delegate keyForUrl:self.url identifier:identifier];
                if (self.cacheOption & SFWebImageCacheOptionMemery) {
                    [self.delegate saveMemeryCache:resultImage forKey:key];
                    if (self.cacheOption & SFWebImageCacheOptionDisk)
                        [self.delegate saveDiskCache:resultImage forKey:key completed:nil];
                }else if (self.cacheOption & SFWebImageCacheOptionDisk) {
                    [self.delegate saveDiskCache:resultImage forKey:key completed:nil];
                }
                completed(resultImage,url,error);
            }else{
                completed(downloadImage,url,error);
            }
        }];
    };
    
    if (self.cacheOption & SFWebImageCacheOptionMemery) {
        UIImage *image = [self memeryImageWithIdentifier:identifier];
        if (image) {
            completed(image, self.url, nil);
        }else{
            if (self.cacheOption & SFWebImageCacheOptionDisk){
                [self diskImageWithIdentifier:identifier handler:^(UIImage *image) {
                    if (image) {
                        completed(image, self.url, nil);
                    }else{
                        noCacheOperation();
                    }
                }];
            }else{
                noCacheOperation();
            }
        }
    }
    if (self.cacheOption & SFWebImageCacheOptionDisk) {
        [self diskImageWithIdentifier:identifier handler:^(UIImage *image) {
            if (image) {
                completed(image, self.url, nil);
            }else{
                noCacheOperation();
            }
        }];
    }
}

- (void)diskImageWithIdentifier:(NSString *)identifier handler:(void(^)(UIImage *image))handler{
    // search in DiskCache with identifier
    NSString *noIdentifierKey = [self.delegate keyForUrl:self.url identifier:nil];
    [self.delegate diskCacheForKey:noIdentifierKey completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (image) {
            handler(image);
            return;
        }
        // search in DiskCache without identifier
        NSString *key = [self.delegate keyForUrl:self.url identifier:identifier];
        [self.delegate diskCacheForKey:key completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
                UIImage *resultImage = [SFImageMakerManager.shared startWithImage:image processors:self.processors];
                handler(resultImage);
                [self.delegate saveDiskCache:resultImage forKey:key completed:nil];
            }else{
                handler(nil);
            }
        }];
    }];
}
- (UIImage *)memeryImageWithIdentifier:(NSString *)identifier{
    // search in MemCache with identifier
    NSString *noIdentifierKey = [self.delegate keyForUrl:self.url identifier:nil];
    UIImage *image = [self.delegate memeryCacheForKey:noIdentifierKey];
    if (image) {
        return image;
    }
    // search in MemCache without identifer
    NSString *key = [self.delegate keyForUrl:self.url identifier:identifier];
    image = [self.delegate memeryCacheForKey:key];
    if (image) {
        UIImage *resultImage = [SFImageMakerManager.shared startWithImage:image processors:self.processors];
        [self.delegate saveMemeryCache:resultImage forKey:key];
        return resultImage;
    }else{
        return nil;
    }
}
@end
