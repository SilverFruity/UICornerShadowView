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
@property (nonatomic, copy)NSURL *url;
@property (nonatomic, copy)NSArray<id<SFImageProcessor>> *processors;

@end
@implementation SFWebImageMakerHelper
- (instancetype)initWithUrl:(NSURL *)url processors:(NSArray<id<SFImageProcessor>> *)processors{
    self = [super init];
    self.url = url;
    self.processors = processors;
    return self;
}
- (void)prcoessWithCompleted:(SFWebImageCompleteHandler)completed{
    if (!self.delegate){
        return;
    }
    NSString *identifier = [SFImageMakerManager.shared identifierWithProcessors:self.processors];
    void (^noCacheOperation)(void) = ^{
        [self.delegate downloadForUrl:self.url completed:^(UIImage * _Nullable downloadImage, NSURL * _Nullable url, NSError * _Nullable error) {
            if (downloadImage){
                UIImage *resultImage = [SFImageMakerManager.shared startWithImage:downloadImage processors:self.processors];
                completed(resultImage,url,error);
                // save without identifier
                [self.delegate saveMemeryCache:downloadImage forUrl:self.url identifier:nil];
                [self.delegate saveDiskCache:downloadImage forUrl:self.url identifier:nil completed:nil];
                
                // save with identifier
                if (self.cacheOption & SFWebImageCacheOptionAll) {
                    [self.delegate saveMemeryCache:resultImage forUrl:self.url identifier:identifier];
                    [self.delegate saveDiskCache:resultImage forUrl:self.url identifier:identifier completed:nil];
                    
                }else if (self.cacheOption & SFWebImageCacheOptionMemery) {
                    [self.delegate saveMemeryCache:resultImage forUrl:self.url identifier:identifier];
                    
                }else if (self.cacheOption & SFWebImageCacheOptionDisk) {
                    [self.delegate saveDiskCache:resultImage forUrl:self.url identifier:identifier completed:nil];
                }
            }
            completed(downloadImage,url,error);
        }];
    };
    
    if (self.cacheOption & SFWebImageCacheOptionAll) {
        [self memeryImageWithIdentifier:identifier handler:^(UIImage *image) {
            if (image) {
                completed(image,self.url,nil);
            }else{
                [self diskImageWithIdentifier:identifier handler:^(UIImage *image) {
                    if (image) {
                        completed(image, self.url, nil);
                    }else{
                        noCacheOperation();
                    }
                }];
            }
        }];
    }else if (self.cacheOption & SFWebImageCacheOptionDisk) {
       [self diskImageWithIdentifier:identifier handler:^(UIImage *image) {
            if (image) {
                completed(image, self.url, nil);
            }else{
                noCacheOperation();
            }
        }];
    }else if (self.cacheOption & SFWebImageCacheOptionDisk) {
        [self memeryImageWithIdentifier:identifier handler:^(UIImage *image) {
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
    [self.delegate diskCacheForUrl:self.url identifier:identifier completed:^(UIImage * _Nullable image, NSURL * _Nullable url, NSError * _Nullable error) {
        if (image) {
            handler(image);
            return;
        }
        // search in DiskCache without identifier
        [self.delegate diskCacheForUrl:self.url identifier:nil completed:^(UIImage * _Nullable image, NSURL * _Nullable url, NSError * _Nullable error) {
            if (image) {
                UIImage *resultImage = [SFImageMakerManager.shared startWithImage:image processors:self.processors];
                handler(resultImage);
                [self.delegate saveDiskCache:resultImage forUrl:self.url identifier:identifier completed:nil];
            }else{
                handler(nil);
            }
        }];
    }];
}
- (void)memeryImageWithIdentifier:(NSString *)identifier handler:(void(^)(UIImage *image))handler{
    // search in MemCache with identifier
    UIImage *image = [self.delegate memeryCacheForUrl:self.url identifier:identifier];
    if (image) {
        handler(image);
        return;
    }
    // search in MemCache without identifer
    image = [self.delegate memeryCacheForUrl:self.url identifier:nil];
    if (image) {
        UIImage *resultImage = [SFImageMakerManager.shared startWithImage:image processors:self.processors];
        handler(image);
        [self.delegate saveMemeryCache:resultImage forUrl:self.url identifier:identifier];
    }else{
        handler(nil);
    }
}
@end
