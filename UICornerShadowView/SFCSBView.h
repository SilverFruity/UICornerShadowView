//
//  SFCSBView.h
//  UICornerShadowView
//
//  Created by Jiang on 2020/2/28.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SFImageMaker/SFImageMaker.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFCSBView : UIView
@property (nonatomic,assign)IBInspectable CGFloat _cornerRadius;
@property (nonatomic,strong)IBInspectable UIColor *_shadowColor;
@property (nonatomic,assign)IBInspectable CGSize _shadowOffset;
@property (nonatomic,assign)IBInspectable CGFloat _shadowRadius;
@property (nonatomic,assign)IBInspectable CGFloat _borderWidth;
@property (nonatomic,strong)IBInspectable UIColor *_borderColor;
@property (nonatomic,assign)IBInspectable UIRectCorner _rectCornner;
@property (nonatomic,assign)IBInspectable UIShadowPostion _shadowPosition;
@property (nonatomic,assign)IBInspectable UIBorderPostion _borderPosition;
@property (nonatomic,nullable,copy)void(^handleMakers)(NSArray <id <SFImageProcessor>> * makers);
@property (nonatomic,readonly)SFShadowImageMaker *shadowProcessor;
@property (nonatomic,readonly)SFCornerImageMaker *cornerProcessor;
@property (nonatomic,readonly)SFBorderImageMaker *borderProcessor;
@property (nonatomic,readonly)SFColorImageMaker  *colorProcessor;
- (void)reloadBackGourndImage;
@end

NS_ASSUME_NONNULL_END
