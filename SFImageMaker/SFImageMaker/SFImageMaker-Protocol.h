//
//  SFImageMaker-Protocol.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SFImageMaker/UIColor+SFIdentifier.h>
NS_ASSUME_NONNULL_BEGIN
@protocol SFImageIdentifier <NSObject>
@property (nonatomic, readonly, getter=isEnable)BOOL enable;
- (NSString *)identifier;
@end

@protocol SFImageProcessor;
@protocol SFImageDependencies <NSObject>
@property(nonatomic, strong)NSMutableArray <id <SFImageProcessor>> *dependencies;
@end

@protocol SFImageProcessor <SFImageIdentifier,SFImageDependencies>
@required
- (UIImage *)process:(nullable UIImage *)target;
@end

@protocol SFImageGenerator <SFImageIdentifier,SFImageDependencies>
@required
@property (nonatomic,assign)CGSize size;
- (instancetype)initWithSize:(CGSize)size;
- (UIImage *)generate;
@end



NS_ASSUME_NONNULL_END
