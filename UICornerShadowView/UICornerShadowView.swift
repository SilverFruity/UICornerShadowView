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
    var _borderPosition:UIBorderPostion = .all
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
        let shadowPosition = self._shadowPosition
        let borderWidth = self._borderWidth
        let borderColor = self._borderColor
        let borderPosition = self._borderPosition
        //FIXME: 外边框 border和shadow同时存在时，宽高的计算，一大一小。
        //FIXME: 外边框 border和shadow只有一者存在时，宽高的计算。
        let imageRect = UIImage.shadowBackGroundImageRect(withViewSize: self.bounds.size, shadowOffset: shadowOffset, shadowRadius: shadowRadius, position: shadowPosition)
        
        //TODO: errorValue:特意增加的误差 0.o。解决tableView显示时，全是阴影的情况，cell衔接时会有一点点点空缺。
        let errorValue :CGFloat = 1
        self.backGroundImageView.frame = imageRect.inset(by: UIEdgeInsets(top: errorValue, left: errorValue, bottom: errorValue, right: errorValue))
        
        if let cacheImage = CustomRenderCache.default.object(forKey: imageIdentifier){
            self.backGroundImageView.image = cacheImage
            self.backgroundColor = UIColor.clear
            return
        }
        DispatchQueue.global().async { [unowned self] in
            // Radius ShadowRadius BorderWidth 取最大值
            var maxValue = radius > (borderWidth + 1) && enableRectConer ? radius : borderWidth + 1
//            FIXME: shadowRadius > cornerRadius时，可能会出现圆角大小显示出错的问题。拉伸导致
            maxValue = shadowRadius > maxValue ? shadowRadius : maxValue
            let size = CGSize.init(width: maxValue * 2, height: maxValue * 2)
            var image = UIImage.init(color: color, size: size)
            if enableRectConer{
                image = image.cornerImage(withRoundingCorners: rectCornner, radius: radius)
            }
            //FIME: 当前是内边框，外边框的情况？
            if borderColor != UIColor.clear && borderWidth != 0{
                image = image.borderPathImage(withRoundingCorners: rectCornner, radius: enableRectConer ? radius : 0, width: borderWidth, position: borderPosition, stroke: borderColor)
            }
            if shadowColor != UIColor.clear && shadowRadius != 0{
                image = image.shadow(shadowOffset, radius: shadowRadius, color: shadowColor, shadowPositoin: shadowPosition)
            }
            image = image.resizableImageCenterMode()
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
            return "CornerShadow_\(initailBackGroundColor)_\(_cornerRadius)_\(_rectCornner)_\(_shadowRadius)_\(_shadowColor)_\(_shadowPosition)_\(_borderColor)_\(_borderWidth)_\(_borderPosition)"
        }else{
            return "CornerShadow_\(_enableRectCornner)_\(initailBackGroundColor)_\(_shadowRadius)_\(_shadowColor)_\(_shadowPosition)_\(_borderColor)_\(_borderWidth)_\(_borderPosition)"
        }
        
    }
    
    #if DEBUG
    func debugInfo()->String{
      return  """
              initailBackGroundColor=\(initailBackGroundColor);\n
              cornerRadius=\(_cornerRadius);\n
              rectCornner=\(_rectCornner);\n
              shadowRadius=\(_shadowRadius);\n
              shadowColor=\(_shadowColor);\n
              shadowPosition=\(_shadowPosition);\n
              borderColor=\(_borderColor);\n
              borderWidth=\(_borderWidth);\n
              borderPosition=\(_borderPosition);
              """
    }
    #endif
    
    
    
}
