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
typedef NS_OPTIONS(NSUInteger, SFWebImageCacheOption){
    SFWebImageCacheOptionNone   = 0,
    SFWebImageCacheOptionMemery = 1,
    SFWebImageCacheOptionDisk   = 1 << 1,
    SFWebImageCacheOptionAll    = ~0UL
};
NS_ASSUME_NONNULL_BEGIN
@protocol SFWebImageManagerDelegate <NSObject>
@required
- (void)downloadForUrl:(NSURL *)url completed:(SFWebImageCompleteHandler)completed;

- (UIImage *)memeryCacheForUrl:(NSURL *)url identifier:(NSString * _Nullable)identifer;
- (void)saveMemeryCache:(UIImage *)image forUrl:(NSURL *)url identifier:(NSString *_Nullable)identifier;

- (void)diskCacheForUrl:(NSURL *)url identifier:(NSString * _Nullable)identifer completed:(SFWebImageCompleteHandler)completed;
- (void)saveDiskCache:(UIImage *)image forUrl:(NSURL *)url identifier:(NSString *_Nullable)identifier completed:(nullable void(^)(NSError *error))completed;
@end

@interface SFWebImageMakerHelper : NSObject
@property (nonatomic, weak)id <SFWebImageManagerDelegate>delegate;
@property (nonatomic, assign)SFWebImageCacheOption cacheOption;
- (instancetype)initWithUrl:(NSURL *)url processors:(NSArray <id<SFImageProcessor>>*)processors;
- (void)prcoessWithCompleted:(SFWebImageCompleteHandler)completed;
@end

NS_ASSUME_NONNULL_END
