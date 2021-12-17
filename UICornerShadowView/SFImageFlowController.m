//
//  SFImageFlowController.m
//  UICornerShadowView
//
//  Created by APPLE on 2021/5/25.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "SFImageFlowController.h"
#import <SFImageMaker/SFImageMaker.h>
#import "UIImage+Extentions.h"
@interface SFImageFlowController ()
@property (weak, nonatomic) IBOutlet UIButton *cornerBorderButton;
@property (weak, nonatomic) IBOutlet UIButton *gradientButton;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet SFCSBView *testView;

@property (weak, nonatomic) IBOutlet SFCSBView *topView;
@property (weak, nonatomic) IBOutlet SFCSBView *bottomView;
@end

@implementation SFImageFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cornerBorderButton setBackgroundImage:UIColor.lightGrayColor.sf_flow.corner(10, UIRectCornerAllCorners).border(0.5, UIColor.blackColor).image forState:UIControlStateNormal];
    UIImage *image =  @[UIColor.redColor,UIColor.purpleColor].sf_gradientFlow(YES,self.gradientButton.frame.size).corner(10, UIRectCornerTopLeft|UIRectCornerBottomRight).border(1, UIColor.blackColor).image;
    [self.gradientButton setBackgroundImage:image forState:UIControlStateNormal];
//    image = @[UIColor.redColor,UIColor.greenColor].sf_gradientFlow(YES,CGSizeMake(40, 40)).blur(SFBlurEffectLight).circle.image;
    image = @[UIColor.redColor,UIColor.greenColor].sf_gradientFlow(YES,CGSizeMake(40, 40)).blur(SFBlurEffectLight).circle.border(1, UIColor.blackColor).shadow([UIColor.blackColor colorWithAlphaComponent:0.5], CGSizeMake(10, 10), 10).image;
    [self.avatarButton setBackgroundImage:image forState:UIControlStateNormal];
    
    image = [UIImage new].sf_flow.corner(10, UIRectCornerAllCorners).border(1, UIColor.redColor).image;
    
    self.testView.cornerRadius = 8;
    self.testView.shadowRadius = 20;
    self.testView.shadowColor = UIColor.blackColor;
    self.testView.borderWidth = 0;
    self.testView.borderColor = [UIColor clearColor];
    
    
    self.topView.cornerRadius = 0;
    self.topView.shadowRadius = 20;
    self.topView.shadowColor = UIColor.blackColor;
    self.topView.rectCornner = UIRectCornerTopLeft | UIRectCornerBottomRight;
    self.topView.shadowPosition = UIShadowPostionLeft | UIShadowPostionRight;
    self.topView.shadowFixValue = -0.2455;
    self.topView.borderWidth = 0;
    self.topView.borderColor = [UIColor clearColor];

    self.bottomView.cornerRadius = 10;
    self.bottomView.shadowRadius = 20;
    self.bottomView.shadowFixValue = -0.2455;
    self.bottomView.shadowPosition = UIShadowPostionLeft | UIShadowPostionRight;
    self.bottomView.rectCornner = UIRectCornerBottomLeft | UIRectCornerTopRight;
    self.bottomView.shadowColor = UIColor.blackColor;
    self.bottomView.borderWidth = 0;
    self.bottomView.borderColor = [UIColor clearColor];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
