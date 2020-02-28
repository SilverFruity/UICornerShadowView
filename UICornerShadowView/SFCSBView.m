//
//  SFCSBView.m
//  UICornerShadowView
//
//  Created by Jiang on 2020/2/28.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFCSBView.h"
#import "UIImage+Extentions.h"

@interface SFCSBViewImageCache: NSObject
@property (nonatomic, strong)NSCache *cache;
@end

@implementation SFCSBViewImageCache
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static SFCSBViewImageCache *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [SFCSBViewImageCache new];
    });
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    self.cache = [[NSCache alloc] init];
    self.cache.totalCostLimit = 10 * 1024 * 1024;
    return self;
}
- (nullable UIImage *)objectForKey:(NSString *)key{
    return [self.cache objectForKey:key];
}
- (void)setObject:(nullable UIImage *)obj forKey:(NSString *)key{
    if (!obj) {
        return;
    }
    [self.cache setObject:obj forKey:key];
}
@end

@interface SFCSBView()
@property (nonatomic, strong)UIColor * initailBackGroundColor;
@property (nonatomic, copy)NSString * lastBackGroundImageIdentifer;
@property (nonatomic, strong)UIImageView * backGroundImageView;
@end
@implementation SFCSBView
- (SFShadowImageMaker *)shadowProcessor{
    SFShadowImageMaker *maker = [[SFShadowImageMaker alloc] init];
    maker.shadowColor = self._shadowColor;
    maker.shadowOffset = self._shadowOffset;
    maker.shadowBlurRadius = self._shadowRadius;
    maker.position = self._shadowPosition;
    return maker;
}
- (SFCornerImageMaker *)cornerProcessor{
    SFCornerImageMaker *maker = [[SFCornerImageMaker alloc] init];
    maker.radius = self._cornerRadius;
    maker.position = self._rectCornner;
    return maker;
}
- (SFBorderImageMaker *)borderProcessor{
    SFBorderImageMaker *maker = [[SFBorderImageMaker alloc] init];
    maker.width = self._borderWidth;
    maker.color = self._borderColor;
    maker.position = self._borderPosition;
    maker.dependency = self.cornerProcessor;
    return maker;
}
- (SFColorImageMaker *)colorProcessor{
    CGFloat maxValue = self.cornerProcessor.radius > (self.borderProcessor.width + 1) && self.cornerProcessor.isEnable ? self.cornerProcessor.radius : self.borderProcessor.width + 1;
    maxValue = self.shadowProcessor.shadowBlurRadius > maxValue ? self.shadowProcessor.shadowBlurRadius : maxValue;
    CGSize size = CGSizeMake(maxValue * 2, maxValue * 2);
    return [SFColorImageMaker imageMakerWithColor:self.initailBackGroundColor size:size];
}
- (UIImageView *)backGroundImageView{
    if (!_backGroundImageView){
        _backGroundImageView = [UIImageView new];
        _backGroundImageView.clipsToBounds = NO;
        [self addSubview:_backGroundImageView];
    }
    return _backGroundImageView;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}
- (void)setDefaultValues{
    self._rectCornner = UIRectCornerAllCorners;
    self._cornerRadius = 8;
    self._shadowColor = [UIColor.blueColor colorWithAlphaComponent:0.08];
    self._shadowOffset = CGSizeZero;
    self._shadowRadius = 0;
    self._borderWidth = 0;
    self._borderColor = UIColor.clearColor;
    self._shadowPosition = UIShadowPostionAll;
    self._borderPosition = UIBorderPostionAll;
    self.clipsToBounds = NO;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self reloadBackGourndImage];
}
- (void)reloadBackGourndImage{
    [self sendSubviewToBack:self.backGroundImageView];
    if (!CGColorEqualToColor(self.backgroundColor.CGColor, UIColor.clearColor.CGColor) && self.backgroundColor != nil) {
        self.initailBackGroundColor = self.backgroundColor;
    }
    SFShadowImageMaker *shadowMaker = self.shadowProcessor;
    SFCornerImageMaker *cornerMaker = self.cornerProcessor;
    SFBorderImageMaker *borderMaker = self.borderProcessor;
    SFColorImageMaker *colorMaker = self.colorProcessor;
    NSString *identifier = [NSString stringWithFormat:@"%@%@%@%@",colorMaker.identifier,cornerMaker.identifier,borderMaker.identifier,shadowMaker.identifier];
    CGRect backImageViewFrame = [shadowMaker viewRectForSize:self.frame.size];
    CGFloat insertValue = -1;
    backImageViewFrame = CGRectInset(backImageViewFrame, insertValue, insertValue);
    if (![identifier isEqualToString:self.lastBackGroundImageIdentifer] || !CGRectEqualToRect(self.backGroundImageView.frame, backImageViewFrame)) {
        self.backGroundImageView.frame = backImageViewFrame;
    }
    UIImage *cacheImage = [[SFCSBViewImageCache shared] objectForKey:identifier];
    if (cacheImage) {
        self.backGroundImageView.image = cacheImage;
        self.backgroundColor = UIColor.clearColor;
        self.lastBackGroundImageIdentifer = identifier;
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [SFImageManager.shared startWithGenerator:colorMaker processors:@[cornerMaker,borderMaker,shadowMaker]];
        if (shadowMaker.isEnable) {
            image = [image resizableImageCenterWithInset:shadowMaker.convasEdgeInsets];
        }else{
            image = [image resizableImageCenterMode];
        }
        [SFCSBViewImageCache.shared setObject:image forKey:identifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf) {
                return;
            }
            weakSelf.lastBackGroundImageIdentifer = identifier;
            weakSelf.backGroundImageView.image = image;
        });
    });
    self.backgroundColor = UIColor.clearColor;
}
@end
