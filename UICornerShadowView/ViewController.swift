//
//  ViewController.swift
//  UICornerShadowView
//
//  Created by Jiang on 2020/1/15.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var shadowView: UICornerShadowView!
    
    @IBOutlet weak var layerCorner: UIView!
    @IBOutlet weak var layerShadow: UIView!
    
    @IBOutlet weak var leftRightShadowView: UICornerShadowView!
    @IBOutlet weak var topBottomShadowView: UICornerShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shadowView._enableRectCornner = true
        self.shadowView._cornerRadius = 20
        self.shadowView._rectCornner = [.topLeft,.topRight,.bottomLeft,.bottomRight]
        self.shadowView._shadowPosition = [.left,.top,.right,.bottom]
        self.shadowView._shadowColor = UIColor.black.withAlphaComponent(0.6)
        self.shadowView._shadowRadius = 20
        self.shadowView._borderColor = UIColor.systemBlue
        self.shadowView._borderWidth = 5
        self.shadowView._borderPosition = .all

        self.layerCorner.layer.borderWidth = self.shadowView._borderWidth
        self.layerCorner.layer.borderColor = self.shadowView._borderColor.cgColor
        self.layerCorner.layer.cornerRadius = self.shadowView._cornerRadius
        self.layerCorner.layer.masksToBounds = true

        self.layerShadow.backgroundColor = UIColor.clear
        self.layerShadow.layer.shadowOpacity = 1.0
        self.layerShadow.layer.shadowOffset = CGSize.zero
        //FIXME: 和系统相同需要 /2
        self.layerShadow.layer.shadowRadius = self.shadowView._shadowRadius / 2
        self.layerShadow.layer.shadowColor = self.shadowView._shadowColor.cgColor
        
        self.leftRightShadowView._enableRectCornner = false
        self.leftRightShadowView._shadowPosition = [.left,.right]
        self.leftRightShadowView._shadowColor = UIColor.black.withAlphaComponent(0.6)
        self.leftRightShadowView._shadowRadius = 20
        self.leftRightShadowView._borderWidth = 5
        self.leftRightShadowView._borderColor = UIColor.systemBlue
        self.leftRightShadowView._borderPosition = [.left,.right]
        
        self.topBottomShadowView._enableRectCornner = false
        self.topBottomShadowView._shadowPosition = [.top,.bottom]
        self.topBottomShadowView._shadowColor = UIColor.black.withAlphaComponent(0.6)
        self.topBottomShadowView._shadowRadius = 20
        self.topBottomShadowView._borderWidth = 5
        self.topBottomShadowView._borderColor = UIColor.systemBlue
        self.topBottomShadowView._borderPosition = [.top,.bottom]

    }
}

