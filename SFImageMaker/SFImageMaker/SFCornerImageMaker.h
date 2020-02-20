//
//  SFRectCornerMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFCornerImageMaker : NSObject
@property (nonatomic, assign)CGFloat radius;
@property (nonatomic, strong)UIColor *fillColor;
@property (nonatomic, assign)UIRectCorner position;
@property (nonatomic, getter=isEnable)BOOL enable;
- (UIImage *)process:(UIImage *)target;
@end

NS_ASSUME_NONNULL_END
