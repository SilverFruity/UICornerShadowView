//
//  UICornerShadowView.swift
//
//  Created by Jiang on 2019/12/5.
//  Copyright © 2019 goute. All rights reserved.
//

import UIKit
import CoreGraphics
class CustomRenderCache{
    static let `default` = CustomRenderCache()
    private let cache: NSCache = NSCache<NSString,UIImage>.init()
    init() {
        //10MB
        self.cache.totalCostLimit =  10 * 1024 * 1024
    }
    open func object(forKey key: String) -> UIImage?{
        return self.cache.object(forKey: NSString.init(string: key))
    }
    
    open func setObject(_ obj: UIImage, forKey key: String){
        // 32: RGBA
        let bytes = Int(obj.size.width * obj.size.height * UIScreen.main.scale * 32)
        self.cache.setObject(obj, forKey: NSString.init(string: key), cost: bytes)
    }
    
    open func removeObject(forKey key: String){
        self.cache.removeObject(forKey: NSString.init(string: key))
    }
    func removeAllObjects(){
        self.cache.removeAllObjects()
    }
}

class UICornerShadowView: UIView {
    var backGroundImageView: UIImageView!
    // 加下划线的原因是与SwifterSwift库有冲突
    // FIXME: 后续添加UIAppearance 全局设置默认值
    @IBInspectable public var _enableRectCornner: Bool = true
    @IBInspectable public var _rectCornner: UIRectCorner = .allCorners
    @IBInspectable public var _cornerRadius: CGFloat = 8
    @IBInspectable public var _shadowColor: UIColor = UIColor.black.withAlphaComponent(0.08)
    @IBInspectable public var _shadowOffset: CGSize = CGSize.init(width: 0, height: 0)
    @IBInspectable public var _shadowRadius: CGFloat = 0
    @IBInspectable public var _borderWidth: CGFloat = 0
    @IBInspectable public var _borderColor: UIColor = UIColor.clear
    var _shadowPosition:UIShadowPostion = .all
    private var initailBackGroundColor = UIColor.white
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backGroundImageView = UIImageView.init()
        self.addSubview(self.backGroundImageView)
        self.backGroundImageView.clipsToBounds = false
        self.clipsToBounds = false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backGroundImageView = UIImageView.init()
        self.addSubview(self.backGroundImageView)
        self.backGroundImageView.clipsToBounds = false
        self.clipsToBounds = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reloadBackGourndImage()
    }
    func reloadBackGourndImage(){
        self.sendSubviewToBack(self.backGroundImageView)
        if self.backgroundColor != UIColor.clear && self.backgroundColor != nil{
            self.initailBackGroundColor = self.backgroundColor!
        }
        let color = self.initailBackGroundColor
        let imageIdentifier = self.identifier()
        
        //保证不会在子线程中调用self获取值
        let enableRectConer = self._enableRectCornner
        let radius = self._cornerRadius
        let rectCornner = self._rectCornner
        let shadowColor = self._shadowColor
        let shadowOffset = self._shadowOffset
        let shadowRadius = self._shadowRadius
        let shadowRadiusOffset = CGSize.init(width: _shadowRadius, height: _shadowRadius)
        let shadowPosition = self._shadowPosition
        let borderWidth = self._borderWidth
        let borderColor = self._borderColor
        let selfSize = self.bounds.size
        //FIXME: border和shadow同时存在时，宽高的计算，一大一小。
        //FIXME: border和shadow只有一者存在时，宽高的计算。
        let viewX = (shadowOffset.width > 0 ? 0 : shadowOffset.width) + (self._shadowPosition.contains(.left) ? -shadowRadiusOffset.width : 0)
        let viewY = (shadowOffset.height > 0 ? 0 : shadowOffset.height) + (self._shadowPosition.contains(.top) ? -shadowRadiusOffset.height : 0)
        let viewSize = UIImage.shadowEdgeSize(with: self.bounds.size, offset: shadowOffset, radius: shadowRadius, position: self._shadowPosition)
        
        //TODO: errorValue:特意增加的误差 0.o。解决tableView显示时，全是阴影的情况，cell衔接时会有一点点点空缺。
        let errorValue :CGFloat = 1
        self.backGroundImageView.frame = CGRect.init(x: viewX - errorValue, y: viewY - errorValue, width: viewSize.width + errorValue * 2, height: viewSize.height + errorValue * 2)
        
        if let cacheImage = CustomRenderCache.default.object(forKey: imageIdentifier){
            self.backGroundImageView.image = cacheImage
            self.backgroundColor = UIColor.clear
            return
        }
        DispatchQueue.global().async { [unowned self] in
            var image = UIImage.init(color: color, size: CGSize.init(width: selfSize.width, height: selfSize.height))
            if enableRectConer{
                image = image.cornerImage(withRoundingCorners: rectCornner, radius: radius)
            }
            //FIME: 究竟是优先绘制border还是shadow，不同的顺序，导致的结果不同。
            if borderColor != UIColor.clear && borderWidth != 0{
                //FIXME: border是否能选择方向? left right top bottom
                image = image.borderPathImage(withRoundingCorners: rectCornner, radius: radius, width: borderWidth, stroke: borderColor)
            }
            if shadowColor != UIColor.clear && shadowRadius != 0{
                image = image.shadow(shadowOffset, radius: shadowRadius, color: shadowColor, shadowPositoin: shadowPosition)
            }
            CustomRenderCache.default.setObject(image, forKey: imageIdentifier)
            DispatchQueue.main.async { [weak self] in
                if self == nil{
                    return
                }
                self?.backGroundImageView.image = image
            }
        }
        self.backgroundColor = UIColor.clear
    }
    func identifier()->String{
        //FIXME: border不启用和shadow不启用时的identifier
        if _enableRectCornner {
            return "CornerShadow_\(self.bounds.size)_\(initailBackGroundColor)_\(_cornerRadius)_\(_rectCornner)_\(_shadowRadius)_\(_shadowColor)_\(_shadowPosition)_\(_borderColor)_\(_borderWidth)"
        }else{
            return "CornerShadow_\(self.bounds.size)_\(_enableRectCornner)_\(initailBackGroundColor)_\(_shadowRadius)_\(_shadowColor)_\(_shadowPosition)_\(_borderColor)_\(_borderWidth)"
        }
        
    }
    
    
    
}
