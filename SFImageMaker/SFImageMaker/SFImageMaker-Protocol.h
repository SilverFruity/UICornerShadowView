//
//  SFImageMaker-Protocol.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SFImageGenerator <NSObject>
@required
- (UIImage *)generate;
@end


@protocol SFImageProcessor <NSObject>
@required
@property (nonatomic, readonly, getter=isEnable)BOOL enable;
- (NSString *)identifer;
- (UIImage *)process:(nullable UIImage *)target;
@optional
@property(nonatomic, strong, nullable)id <SFImageProcessor> dependency;
@end



NS_ASSUME_NONNULL_END
