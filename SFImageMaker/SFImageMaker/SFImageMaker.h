//
//  SFImageMaker.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for SFImageMaker.
FOUNDATION_EXPORT double SFImageMakerVersionNumber;

//! Project version string for SFImageMaker.
FOUNDATION_EXPORT const unsigned char SFImageMakerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SFImageMaker/PublicHeader.h>
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif

#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

#ifndef SCREEN_SCALE
#define SCREEN_SCALE [UIScreen mainScreen].scale
#endif

#import <SFImageMaker/SFColorImageMaker.h>
#import <SFImageMaker/SFGradientImageMaker.h>
#import <SFImageMaker/SFCornerImageMaker.h>
#import <SFImageMaker/SFShadowImageMaker.h>
#import <SFImageMaker/SFBorderImageMaker.h>
