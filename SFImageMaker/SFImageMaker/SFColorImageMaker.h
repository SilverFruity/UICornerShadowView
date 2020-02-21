//
//  SFColorImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFColorImageMaker : NSObject <SFImageGenerator,SFImageProcessor>
@property (nonatomic, assign)CGSize size;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, getter=isEnable)BOOL enable;
+ (instancetype)imageMakerWithColor:(UIColor *)color;
+ (instancetype)imageMakerWithColor:(UIColor *)color size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
