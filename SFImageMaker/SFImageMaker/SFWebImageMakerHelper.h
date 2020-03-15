//
//  SFWebImageProcessor.h
//  SFImageMaker
//
//  Created by Jiang on 2020/3/13.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFImageMaker-Protocol.h"
/**
 *  input: Url + processors
 *  search in WebImageFramework Cache with url + identifier
 *  success:
 *      processors process and call completeHandler
 *      return
 *  error: next
 *  search in WebImageFramework Cache with url
 *  success:
 *      processors process and call completeHandler
 *      save in WebImageFramework Cache with url + identifier
 *      return
 *  error: next
 *  use WebImageFramewor Download
 *  success:
 *      processors process and call completeHandler
 *      save in WebImageFramework Cache with url
 *      save in WebImageFramework Cache with url + identifier
 *      return
 *  error: complete with error
 **/
typedef void(^SFWebImageCompleteHandler)(UIImage * _Nullable image,NSURL * _Nullable url,NSError * _Nullable error);
typedef NS_OPTIONS(NSUInteger, SFWebImageCacheSaveOption){
    SFWebImageCacheSaveOptionNone   = 0,
    SFWebImageCacheSaveOptionOriginalMemery = 1,
    SFWebImageCacheSaveOptionOriginalDisk   = 1 << 1,
    SFWebImageCacheSaveOptionResultMemery = 1 << 2,
    SFWebImageCacheSaveOptionResultDisk = 1 << 3,
    SFWebImageCacheSaveOptionAll    = ~0UL
};
NS_ASSUME_NONNULL_BEGIN
@protocol SFWebImageManagerDelegate <NSObject>
@required
- (void)downloadForUrl:(NSURL *)url completed:(SFWebImageCompleteHandler)completed;

- (NSString *)keyForUrl:(NSURL *)url identifier:(nullable NSString *)identifier;

- (nullable UIImage *)memeryCacheForKey:(NSString *)key;
- (void)saveMemeryCache:(UIImage *)image forKey:(NSString *)key;

- (void)diskCacheForKey:(NSString *)key completed:(nullable void(^)(UIImage * _Nullable image,NSError * _Nullable error))completed;
- (void)saveDiskCache:(UIImage *)image forKey:(NSString *)key completed:(nullable void(^)(NSError *_Nullable error))completed;

@end

@interface SFWebImageMakerHelper : NSObject
@property (nonatomic, weak)id <SFWebImageManagerDelegate>delegate;
@property (nonatomic, assign)SFWebImageCacheSaveOption saveOption;
@property (nonatomic, readonly)NSString *identifier;
@property (nonatomic, readonly, strong)NSURL *url;
- (instancetype)initWithUrl:(nullable NSURL *)url processors:(NSArray <id<SFImageProcessor>>*)processors;
- (void)prcoessWithCompleted:(SFWebImageCompleteHandler)completed;
@end

NS_ASSUME_NONNULL_END
