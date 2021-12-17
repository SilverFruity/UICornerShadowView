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
@property (nonatomic,assign)IBInspectable CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong)IBInspectable UIColor *shadowColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign)IBInspectable CGSize shadowOffset  UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign)IBInspectable CGFloat shadowRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign)IBInspectable CGFloat borderWidth  UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong)IBInspectable UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign)IBInspectable UIRectCorner rectCornner UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign)IBInspectable UIShadowPostion shadowPosition UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign)IBInspectable UIBorderPostion borderPosition UI_APPEARANCE_SELECTOR;
@property (nonatomic,nullable,copy)void(^handleMakers)(NSArray <id <SFImageDependencies,SFImageIdentifier>> * makers);
@property (nonatomic,strong)Class defautlGeneratorClass;
@property (nonatomic,readonly)id <SFImageGenerator>  imageGenerator;
@property (nonatomic,readonly)SFShadowImageMaker *shadowProcessor;
@property (nonatomic,readonly)SFCornerImageMaker *cornerProcessor;
@property (nonatomic,readonly)SFBorderImageMaker *borderProcessor;
// 用于解决阴影衔接问题，通常不会用到，默认值为0
// 需要解决时，可以将其设置为 -0.5 或者 -0.25
@property (nonatomic,assign)CGFloat shadowFixValue;
- (void)reloadBackGourndImage;
@end

NS_ASSUME_NONNULL_END
