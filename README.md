[![CI Status](https://img.shields.io/travis/389185764@qq.com/SDWebImage-SFImageMaker.svg?style=flat)](https://travis-ci.org/389185764@qq.com/SDWebImage-SFImageMaker)
[![Version](https://img.shields.io/cocoapods/v/SFImageMaker.svg?style=flat)](https://cocoapods.org/pods/SFImageMaker)
[![License](https://img.shields.io/cocoapods/l/SFImageMaker.svg?style=flat)](https://cocoapods.org/pods/SFImageMaker)
[![Platform](https://img.shields.io/cocoapods/p/SFImageMaker.svg?style=flat)](https://cocoapods.org/pods/SFImageMaker)

[掘金](https://juejin.im/post/5e1e08c36fb9a030080c9427)

# SFCSBView
iOS UIView Subclass: Use CoreGraphics to control the direction of Rect Corner、Shadow 、Border
## Example
```objective-c
// UIAppearance
[SFCSBView appearance].cornerRadius = 20;
[SFCSBView appearance].rectCornner = UIRectCornerAllCorners;
[SFCSBView appearance].shadowPosition = UIShadowPostionAll;
[SFCSBView appearance].shadowRadius = 20;
[SFCSBView appearance].borderColor = [UIColor systemBlueColor];
[SFCSBView appearance].borderWidth = 5;
[SFCSBView appearance].borderPosition = UIBorderPostionAll;


SFCSBView * shadowView = [SFCSBView new];
shadowView.cornerRadius = 20;
shadowView.rectCornner = UIRectCornerAllCorners;
shadowView.shadowPosition = UIShadowPostionAll;
shadowView.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
shadowView.shadowRadius = 20;
shadowView.borderColor = UIColor.systemBlueColor;
shadowView.borderWidth = 5;
shadowView.borderPosition = UIBorderPostionAll;

// UIAppearance
[SFCSBView appearance].cornerRadius = 20;
[SFCSBView appearance].rectCornner = UIRectCornerAllCorners;
[SFCSBView appearance].shadowPosition = UIShadowPostionAll;
[SFCSBView appearance].shadowRadius = 20;
[SFCSBView appearance].borderColor = [UIColor systemBlueColor];
[SFCSBView appearance].borderWidth = 5;
[SFCSBView appearance].borderPosition = UIBorderPostionAll;

// Generate UIImage by color or gradient colors, then start UIImage process flow
UIColor.lightGrayColor.sf_flow.corner(10, UIRectCornerAllCorners).border(0.5, UIColor.blackColor).image;
@[UIColor.redColor,UIColor.purpleColor].sf_gradientFlow(YES,self.gradientButton.frame.size).corner(10, UIRectCornerTopLeft|UIRectCornerBottomRight).border(1, UIColor.blackColor).image

// UIImage Process Flow
[UIImage new].sf_flow.circle.resize(CGSizeMake(40, 40)).blur(SFBlurEffectLight).corner(10, UIRectEdgeAll).border(1, UIColor.redColor)
```

## CocoaPods
```
pod 'SFImageMaker'
```

## Preview

**Compare with CALayer**

![compare with CALayer](https://user-gold-cdn.xitu.io/2020/2/12/1703a1d3defd6b75?imageslim)

**Random Cells**

![Review](https://user-gold-cdn.xitu.io/2020/2/13/1703a26ff78b7732?imageslim)



## Performance

1000 shadow images only need 29MB and 1.01s

In this condition, maximum cpu occupancy rates is 45% and 60FPS when the count of cell is 1000 and quick slide，use iPhone 7, iOS13.3.1.

![](https://user-gold-cdn.xitu.io/2020/2/13/1703e06843524f23?imageslim)

![](https://user-gold-cdn.xitu.io/2020/2/13/1703e0dab3941395?imageslim)

In extreme cases，no reuse,  maximum cpu occupancy rates is 140% and 60FPS when the count of cell is 1000 and quick slide.

![Review](https://user-gold-cdn.xitu.io/2020/2/13/1703a26ff78b7732?imageslim)

![](https://user-gold-cdn.xitu.io/2020/2/13/1703d3b50c47b1c1?imageslim)
