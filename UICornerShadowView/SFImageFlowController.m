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
@end

@implementation SFImageFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cornerBorderButton setBackgroundImage:UIColor.lightGrayColor.sf_flow.corner(10, UIRectCornerAllCorners).border(0.5, UIColor.blackColor).image forState:UIControlStateNormal];
    UIImage *image =  @[UIColor.redColor,UIColor.purpleColor].sf_gradientFlow(YES,self.gradientButton.frame.size).corner(10, UIRectCornerTopLeft|UIRectCornerBottomRight).border(1, UIColor.blackColor).image;
    [self.gradientButton setBackgroundImage:image forState:UIControlStateNormal];
    image = @[UIColor.redColor,UIColor.greenColor].sf_gradientFlow(YES,CGSizeMake(40, 40)).blur(SFBlurEffectLight).circle.image;
    [self.avatarButton setBackgroundImage:image forState:UIControlStateNormal];
    
//    [SFImageFlow flowWithImage:[UIImage new]].corner(10, UIRectEdgeAll).border(1, UIColor.redColor);
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
