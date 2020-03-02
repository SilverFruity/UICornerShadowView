//
//  ViewController.swift
//  UICornerShadowView
//
//  Created by Jiang on 2020/1/15.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import UIKit
import SFImageMaker
class ViewController: UIViewController {
    @IBOutlet weak var shadowView: SFCSBView!
    
    @IBOutlet weak var layerCorner: UIView!
    @IBOutlet weak var layerShadow: UIView!
    
    @IBOutlet weak var leftRightShadowView: SFCSBView!
    @IBOutlet weak var topBottomShadowView: SFCSBView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shadowView.cornerRadius = 20
        self.shadowView.rectCornner = [.topLeft,.topRight,.bottomLeft,.bottomRight]
        self.shadowView.shadowPosition = [.left,.top,.right,.bottom]
        self.shadowView.shadowColor = UIColor.black.withAlphaComponent(0.6)
        self.shadowView.shadowRadius = 20
        self.shadowView.borderColor = UIColor.systemBlue
        self.shadowView.borderWidth = 5
        self.shadowView.borderPosition = .all

        self.layerCorner.layer.borderWidth = self.shadowView.borderWidth
        self.layerCorner.layer.borderColor = self.shadowView.borderColor.cgColor
        self.layerCorner.layer.cornerRadius = self.shadowView.cornerRadius
        self.layerCorner.layer.masksToBounds = true

        self.layerShadow.backgroundColor = UIColor.clear
        self.layerShadow.layer.shadowOpacity = 1.0
        self.layerShadow.layer.shadowOffset = CGSize.zero
        //FIXME: 和系统相同需要 /2
        self.layerShadow.layer.shadowRadius = self.shadowView.shadowRadius / 2
        self.layerShadow.layer.shadowColor = self.shadowView.shadowColor.cgColor
        
        self.leftRightShadowView.cornerRadius = 0
        self.leftRightShadowView.shadowPosition = [.left,.right]
        self.leftRightShadowView.shadowColor = UIColor.black.withAlphaComponent(0.6)
        self.leftRightShadowView.shadowRadius = 20
        self.leftRightShadowView.borderWidth = 5
        self.leftRightShadowView.borderColor = UIColor.systemBlue
        self.leftRightShadowView.borderPosition = [.left,.right]
        
        self.topBottomShadowView.cornerRadius = 0
        self.topBottomShadowView.shadowPosition = [.top,.bottom]
        self.topBottomShadowView.shadowColor = UIColor.black.withAlphaComponent(0.6)
        self.topBottomShadowView.shadowRadius = 20
        self.topBottomShadowView.borderWidth = 5
        self.topBottomShadowView.borderColor = UIColor.systemBlue
        self.topBottomShadowView.borderPosition = [.top,.bottom]

    }
}

