# UICornerShadowView
iOS UIView Subclass: Use CoreGraphics to control the direction of Rect Corner、Shadow 、Border
# Usage
## Swift
```swift
let shadowView = UICornerShadowView.init()
shadowView._cornerRadius = 20
shadowView._rectCornner = [.topLeft,.topRight,.bottomLeft,.bottomRight]
shadowView._shadowPosition = [.left,.top,.right,.bottom]
shadowView._shadowColor = UIColor.black.withAlphaComponent(0.6)
shadowView._shadowRadius = 20
shadowView._borderColor = UIColor.systemBlue
shadowView._borderWidth = 5
shadowView._borderPosition = .all

```

## Objective-C: will come soon

**Compare with CALayer**

![compare with CALayer](https://user-gold-cdn.xitu.io/2020/2/12/1703a1d3defd6b75?imageslim)

**Preview**

![Review](https://user-gold-cdn.xitu.io/2020/2/13/1703a26ff78b7732?imageslim)

~~~

~~~
