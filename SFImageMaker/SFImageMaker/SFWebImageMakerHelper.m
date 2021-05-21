//
//  SFWebImageProcessor.m
//  SFImageMaker
//
//  Created by Jiang on 2020/3/13.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFWebImageMakerHelper.h"
#import <SFImageMaker/SFImageMaker.h>
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
    return sf_identifierWithProcessors(self.processors);
}
- (void)prcoessWithCompleted:(SFWebImageCompleteHandler)completed{
    if (!self.url) {
        completed(nil,nil,[NSError errorWithDomain:@"SFWebImageMakerHelper" code:1 userInfo:@{NSLocalizedDescriptionKey:@"SFWebImageMakerHelper url is nil"}]);
        return;
    }
    if (!self.delegate){
        completed(nil,self.url,[NSError errorWithDomain:@"SFWebImageMakerHelper" code:0 userInfo:@{NSLocalizedDescriptionKey:@"SFWebImageMakerHelper delegate is nil"}]);
        return;
    }
    NSString *identifier = self.identifier;
    void (^noCacheOperation)(void) = ^{
        [self.delegate downloadForUrl:self.url completed:^(UIImage * _Nullable downloadImage, NSURL * _Nullable url, NSError * _Nullable error) {
            if (!error){
                SFImageFlow *processor = [SFImageFlow flowWithImage:downloadImage];
                processor.processors = [self.processors mutableCopy];
                UIImage *resultImage = [processor image];
                // save without identifier
                NSString *noIdentifierKey = [self.delegate keyForUrl:self.url identifier:nil];
                if (self.saveOption & SFWebImageCacheSaveOptionOriginalMemery) {
                    [self.delegate saveMemeryCache:downloadImage forKey:noIdentifierKey];
                }
                if (self.saveOption & SFWebImageCacheSaveOptionOriginalDisk) {
                    [self.delegate saveDiskCache:downloadImage forKey:noIdentifierKey completed:nil];
                }
                
                // save with identifier
                NSString *key = [self.delegate keyForUrl:self.url identifier:identifier];
                if (self.saveOption & SFWebImageCacheSaveOptionResultMemery) {
                    [self.delegate saveMemeryCache:resultImage forKey:key];
                }
                if (self.saveOption & SFWebImageCacheSaveOptionResultDisk) {
                    [self.delegate saveDiskCache:resultImage forKey:key completed:nil];
                }
                completed(resultImage,url,error);
            }else{
                completed(nil,url,error);
            }
        }];
    };
    
    UIImage *image = [self memeryImageWithIdentifier:identifier];
    if (image) {
        completed(image, self.url, nil);
        return;
    }
    [self diskImageWithIdentifier:identifier handler:^(UIImage *image) {
        if (image) {
            completed(image, self.url, nil);
        }else{
            noCacheOperation();
        }
    }];
}

- (void)diskImageWithIdentifier:(NSString *)identifier handler:(void(^)(UIImage *image))handler{
    // search in DiskCache with identifier
    NSString *key = [self.delegate keyForUrl:self.url identifier:identifier];
    [self.delegate diskCacheForKey:key completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!error) {
            if (self.saveOption & SFWebImageCacheSaveOptionResultDisk) {
                [self.delegate saveDiskCache:image forKey:key completed:nil];
            }
            if (self.saveOption & SFWebImageCacheSaveOptionResultDisk) {
                [self.delegate saveMemeryCache:image forKey:key];
            }
            handler(image);
            return;
        }
        // search in DiskCache without identifier
        NSString *noIdentifierKey = [self.delegate keyForUrl:self.url identifier:nil];
        [self.delegate diskCacheForKey:noIdentifierKey completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (!error) {
                SFImageFlow *processor = [SFImageFlow flowWithImage:image];
                processor.processors = [self.processors mutableCopy];
                UIImage *resultImage = [processor image];
                if (self.saveOption & SFWebImageCacheSaveOptionOriginalMemery) {
                    [self.delegate saveMemeryCache:resultImage forKey:noIdentifierKey];
                }
                if (self.saveOption & SFWebImageCacheSaveOptionResultDisk) {
                    [self.delegate saveDiskCache:resultImage forKey:key completed:nil];
                }
                if (self.saveOption & SFWebImageCacheSaveOptionResultDisk) {
                    [self.delegate saveMemeryCache:resultImage forKey:key];
                }
                handler(resultImage);
                return;
            }
            handler(nil);
        }];
    }];
    
}
- (UIImage *)memeryImageWithIdentifier:(NSString *)identifier{
    // search in MemCache with identifier
    NSString *key = [self.delegate keyForUrl:self.url identifier:identifier];
    UIImage *image = [self.delegate memeryCacheForKey:key];
    if (image) {
        return image;
    }
    // search in MemCache without identifer
    NSString *noIdentifierKey = [self.delegate keyForUrl:self.url identifier:nil];
    image = [self.delegate memeryCacheForKey:noIdentifierKey];
    if (image) {
        SFImageFlow *processor = [SFImageFlow flowWithImage:image];
        processor.processors = [self.processors mutableCopy];
        UIImage *resultImage = [processor image];
        if (self.saveOption & SFWebImageCacheSaveOptionResultMemery) {
            [self.delegate saveMemeryCache:resultImage forKey:key];
        }
        return resultImage;
    }
    return nil;
}
@end
