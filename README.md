# UICornerShadowView
iOS UIView Subclass: Use CoreGraphics to control the direction of Rect Corner、Shadow 、Border
# Usage
## Cocoapods
```
pod 'SFImageMaker'
```
## Swift
```swift
let shadowView = SFCSBView.init()
shadowView._cornerRadius = 20
shadowView._rectCornner = [.topLeft,.topRight,.bottomLeft,.bottomRight]
shadowView._shadowPosition = [.left,.top,.right,.bottom]
shadowView._shadowColor = UIColor.black.withAlphaComponent(0.6)
shadowView._shadowRadius = 20
shadowView._borderColor = UIColor.systemBlue
shadowView._borderWidth = 5
shadowView._borderPosition = .all

```

## Objective-C
```objective-c
SFCSBView * shadowView = [SFCSBView new];
shadowView._cornerRadius = 20;
shadowView._rectCornner = UIRectCornerAllCorners;
shadowView._shadowPosition = UIShadowPostionAll;
shadowView._shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
shadowView._shadowRadius = 20;
shadowView._borderColor = UIColor.systemBlueColor;
shadowView._borderWidth = 5;
shadowView._borderPosition = UIBorderPostionAll;
```

**Compare with CALayer**

![compare with CALayer](https://user-gold-cdn.xitu.io/2020/2/12/1703a1d3defd6b75?imageslim)

**Preview**

![Review](https://user-gold-cdn.xitu.io/2020/2/13/1703a26ff78b7732?imageslim)

~~~

~~~
