//
//  UIColor+SFIdentifier.m
//  SFImageMaker
//
//  Created by Jiang on 2021/1/20.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "UIColor+SFIdentifier.h"

@implementation UIColor (SFIdentifier)
- (NSString *)sf_identifier{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    return [NSString stringWithFormat:@"color_%.2f%.2f%2.f%.2f",red,green,blue,alpha];
}
@end
