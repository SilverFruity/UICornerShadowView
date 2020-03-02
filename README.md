# SFCSBView
iOS UIView Subclass: Use CoreGraphics to control the direction of Rect Corner、Shadow 、Border

## Preview

**Compare with CALayer**

![compare with CALayer](https://user-gold-cdn.xitu.io/2020/2/12/1703a1d3defd6b75?imageslim)

**Random Cells**

![Review](https://user-gold-cdn.xitu.io/2020/2/13/1703a26ff78b7732?imageslim)

## Example
```objective-c
SFCSBView * shadowView = [SFCSBView new];
shadowView.cornerRadius = 20;
shadowView.rectCornner = UIRectCornerAllCorners;
shadowView.shadowPosition = UIShadowPostionAll;
shadowView.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
shadowView.shadowRadius = 20;
shadowView.borderColor = UIColor.systemBlueColor;
shadowView.borderWidth = 5;
shadowView.borderPosition = UIBorderPostionAll;
```

## CocoaPods
```
pod 'SFImageMaker'
```


## Performance

1000 shadow images only need 29MB and 1.01s

In this condition, maximum cpu occupancy rates is 45% and 60FPS when the count of cell is 1000 and quick slide，use iPhone 7, iOS13.3.1.

![](https://user-gold-cdn.xitu.io/2020/2/13/1703e06843524f23?imageslim)

![](https://user-gold-cdn.xitu.io/2020/2/13/1703e0dab3941395?imageslim)

In extreme cases，no reuse,  maximum cpu occupancy rates is 140% and 60FPS when the count of cell is 1000 and quick slide.

![Review](https://user-gold-cdn.xitu.io/2020/2/13/1703a26ff78b7732?imageslim)

![](https://user-gold-cdn.xitu.io/2020/2/13/1703d3b50c47b1c1?imageslim)

