//
//  UIKit+SFImageFlow.h
//  SFImageMaker
//
//  Created by APPLE on 2021/5/21.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SFImageFlow;
@interface UIColor (SFImageFlow)
@property (nonatomic, readonly)SFImageFlow *sf_flow;
@property (nonatomic, readonly)SFImageFlow *(^sf_flowWithSize)(CGSize size);
@end

@class SFImageFlow;
@interface UIImage (SFImageFlow)
@property (nonatomic, readonly)SFImageFlow *sf_flow;
@end

@class SFImageFlow;
@interface NSArray (SFImageFlow)
@property (nonatomic, readonly)SFImageFlow *(^sf_gradientFlow)(BOOL isHorizontal);
@end

NS_ASSUME_NONNULL_END
