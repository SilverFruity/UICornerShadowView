//
//  UICornerShadowView.swift
//
//  Created by Jiang on 2019/12/5.
//  Copyright © 2019 goute. All rights reserved.
//

import UIKit
import CoreGraphics
import SFImageMaker

class CustomRenderCache{
    static let `default` = CustomRenderCache()
    private let cache: NSCache = NSCache<NSString,UIImage>.init()
    private var hasCost: Int = 0
    init() {
        //10MB
        self.cache.totalCostLimit =  10 * 1024 * 1024
    }
    open func object(forKey key: String) -> UIImage?{
        return self.cache.object(forKey: NSString.init(string: key))
    }
    
    open func setObject(_ obj: UIImage?, forKey key: String){
        guard let obj = obj else{
            return
        }
        // 32: RGBA
        var bytes = Int(obj.size.width * obj.size.height * 4 * UIScreen.main.scale * UIScreen.main.scale)
        if let cgimg = obj.cgImage{
            bytes = cgimg.height * cgimg.width * (cgimg.bitsPerPixel / cgimg.bitsPerComponent)
        }
        hasCost += bytes
        self.cache.setObject(obj, forKey: NSString.init(string: key), cost: bytes)
    }
    
    open func removeObject(forKey key: String){
        self.cache.removeObject(forKey: NSString.init(string: key))
    }
    func clear(){
        self.cache.removeAllObjects()
    }
    func cacheCost()->Int{
        return hasCost
    }
}

class UICornerShadowView: UIView {
    var backGroundImageView: UIImageView!
    // 加下划线的原因是与SwifterSwift库有冲突
    // FIXME: 后续添加UIAppearance 全局设置默认值
    @IBInspectable public var _rectCornner: UIRectCorner = .allCorners
    @IBInspectable public var _cornerRadius: CGFloat = 8
    @IBInspectable public var _shadowColor: UIColor = UIColor.black.withAlphaComponent(0.08)
    @IBInspectable public var _shadowOffset: CGSize = CGSize.init(width: 0, height: 0)
    @IBInspectable public var _shadowRadius: CGFloat = 0
    @IBInspectable public var _borderWidth: CGFloat = 0
    @IBInspectable public var _borderColor: UIColor = UIColor.clear
    var _shadowPosition:UIShadowPostion = .all
    var _borderPosition:UIBorderPostion = .all
    
    var shadowProcesser: SFShadowImageMaker{
        let shadow = SFShadowImageMaker.init()
        shadow.shadowColor = self._shadowColor
        shadow.shadowOffset = self._shadowOffset
        shadow.shadowBlurRadius = self._shadowRadius
        shadow.position = self._shadowPosition
        return shadow;
    }
    var rectCornerProcesser: SFCornerImageMaker{
        let rectCorner = SFCornerImageMaker.init()
        rectCorner.position = self._rectCornner
        rectCorner.radius = self._cornerRadius
        return rectCorner
    }
    var borderProcesser: SFBorderImageMaker{
        let border = SFBorderImageMaker.init()
        border.width = self._borderWidth
        border.color = self._borderColor
        border.position = self._borderPosition
        border.dependency = self.rectCornerProcesser
        return border;
    }
    var generalImageProcesser: SFColorImageMaker{
        // Radius ShadowRadius BorderWidth 取最大值
        var maxValue = self.rectCornerProcesser.radius > (self.borderProcesser.width + 1) && self.rectCornerProcesser.isEnable ? self.rectCornerProcesser.radius : self.borderProcesser.width + 1
        maxValue = self.shadowProcesser.shadowBlurRadius > maxValue ? self.shadowProcesser.shadowBlurRadius : maxValue
        let size = CGSize.init(width: maxValue * 2, height: maxValue * 2)
        return SFColorImageMaker.init(color: self.initailBackGroundColor, size: size)
    }
    private var initailBackGroundColor = UIColor.white
    // 针对上一次图片的identifier的
    private var lastBackGroundImageIdentifer = ""
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
        //保证不会在子线程中调用self获取值
        let generalImage = self.generalImageProcesser
        let shadow = self.shadowProcesser
        let rectCorner = self.rectCornerProcesser
        let border = self.borderProcesser
        let imageIdentifier = self.identifier()
        
        //FIXME: 外边框 border和shadow同时存在时，宽高的计算，一大一小。
        //FIXME: 外边框 border和shadow只有一者存在时，宽高的计算。
        var viewFrame = shadow.viewRect(for: self.bounds.size)
        //insetValue: 特意增加的误差 0.o。解决tableView显示时，cell上下阴影衔接时会有一空缺的问题。
        let insetValue :CGFloat = -1
        // CGRect(2,2,2,2) -> CGRect(1,1,4,4)
        viewFrame = viewFrame.inset(by: UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue))
        // 每修改一次subview的frame，view会调用layoutSubviews方法。
        // 目的：在高度重用UICornerShadowView的情况，并且每次都更新的情况下，减少frame更新。
        // 如果上一次的identifer相同说明是重用图片
        // 如果当前frame和需要的frame相同，也不用更新frame
        if imageIdentifier != lastBackGroundImageIdentifer || self.backGroundImageView.frame != viewFrame{
            self.backGroundImageView.frame = viewFrame
        }
        if let cacheImage = CustomRenderCache.default.object(forKey: imageIdentifier){
            self.backGroundImageView.image = cacheImage
            self.backgroundColor = UIColor.clear
            self.lastBackGroundImageIdentifer = imageIdentifier
            return
        }
        DispatchQueue.global().async { [unowned self] in
            var image = SFImageManager.shared().start(with: generalImage, processors: [rectCorner,border,shadow])
            if shadow.isEnable{
                let insets = shadow.convasEdgeInsets()
                image = image.resizableImageCenter(withInset: insets)
            }else{
                image = image.resizableImageCenterMode()
            }
            CustomRenderCache.default.setObject(image, forKey: imageIdentifier)
            DispatchQueue.main.async { [weak self] in
                if self == nil{
                    return
                }
                self?.lastBackGroundImageIdentifer = imageIdentifier
                self?.backGroundImageView.image = image
            }
        }
        self.backgroundColor = UIColor.clear
    }
    func identifier()->String{
        return self.generalImageProcesser.identifier() + self.rectCornerProcesser.identifier() + self.borderProcesser.identifier() + self.shadowProcesser.identifier()
    }
    
    #if DEBUG
    func debugInfo()->String{
        return  """
        initailBackGroundColor=\(initailBackGroundColor);\n
        cornerRadius=\(_cornerRadius);\n
        rectCornner=\(_rectCornner);\n
        shadowOffset=\(_shadowOffset);\n
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
