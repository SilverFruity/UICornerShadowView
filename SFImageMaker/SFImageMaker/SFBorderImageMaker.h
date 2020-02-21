//
//  SFBorderImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class SFCornerImageMaker;
typedef NS_OPTIONS(NSUInteger, UIBorderPostion) {
    UIBorderPostionTop      = 1 << 0,
    UIBorderPostionRight    = 1 << 1,
    UIBorderPostionBottom   = 1 << 2,
    UIBorderPostionLeft     = 1 << 3,
    UIBorderPostionAll      = ~0UL
};

@interface SFBorderImageMaker: NSObject <SFImageProcessor>
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, assign)UIBorderPostion position;
@property (nonatomic, getter=isEnable)BOOL enable;
@property(nonatomic, strong, nullable)id <SFImageProcessor> dependency;
- (CGRect)strokeRectWithSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
