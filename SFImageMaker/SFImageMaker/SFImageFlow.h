//
//  SFImageManager.h
//  SFImageMaker
//
//  Created by Jiang on 2020/2/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFImageMaker-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

NSString *sf_identifierWithProcessors(NSArray *processors);
NSString *sf_identifierWithGenerator(id generator, NSArray *processors);

@interface SFImageFlow : NSObject
@property (nonatomic, nullable, strong)UIImage *targetImage;
@property (nonatomic, nullable, strong)id <SFImageGenerator> generator;

@property (nonatomic, nullable, strong)id lastProcessor;
@property (nonatomic, nullable, strong)NSMutableArray *processors;

+ (instancetype)flowWithImage:(UIImage *)targetImage;
+ (instancetype)flowWithGenerator:(id <SFImageGenerator>)generator;
- (void)appendProcessor:(id)processor;
- (UIImage *)image;
- (NSString *)identifier;
@end
NS_ASSUME_NONNULL_END

#import <SFImageMaker/SFBorderImageMaker.h>
NS_ASSUME_NONNULL_BEGIN
@interface SFImageFlow (Processor)
@property (nonatomic, readonly)SFImageFlow* (^corner)(CGFloat radius, UIRectCorner rectCorner);
@property (nonatomic, readonly)SFImageFlow* (^border)(CGFloat width, UIColor *color);
@property (nonatomic, readonly)SFImageFlow* (^borderWithPosition)(UIBorderPostion position, CGFloat width, UIColor *color);
@property (nonatomic, readonly)SFImageFlow* (^shadow)(UIColor *color, CGSize offset, CGFloat blurRadius);
@end
NS_ASSUME_NONNULL_END
