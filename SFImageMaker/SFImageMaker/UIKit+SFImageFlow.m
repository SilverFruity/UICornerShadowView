//
//  UIKit+SFImageFlow.m
//  SFImageMaker
//
//  Created by APPLE on 2021/5/21.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "UIKit+SFImageFlow.h"
#import "SFImageMaker.h"
@implementation UIColor (SFImageFlow)
- (SFImageFlow *)sf_flow{
    SFColorImageMaker *maker = [SFColorImageMaker imageMakerWithColor:self];
    return [SFImageFlow flowWithGenerator:maker];;
}
- (SFImageFlow * _Nonnull (^)(CGSize))sf_flowWithSize{
    return  ^SFImageFlow* (CGSize size){
        SFColorImageMaker *maker = [SFColorImageMaker imageMakerWithColor:self size:size];
        return [SFImageFlow flowWithGenerator:maker];;
    };
}
@end


@implementation UIImage (SFImageFlow)
- (SFImageFlow *)sf_flow{
    return [SFImageFlow flowWithImage:self];;
}
@end


@implementation NSArray (SFImageFlow)
- (SFImageFlow * _Nonnull (^)(BOOL, CGSize))sf_gradientFlow{
    return  ^SFImageFlow* (BOOL isHorizontal, CGSize size){
        NSAssert(self.count == 2, @"");
        SFGradientImageMaker *maker = [SFGradientImageMaker isHorizontal:isHorizontal startColor:self[0] endColor:self[1]];
        maker.size = size;
        return [SFImageFlow flowWithGenerator:maker];
    };
}

@end
