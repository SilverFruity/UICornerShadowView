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
    @IBOutlet weak var leftRightShadowView: UICornerShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shadowView._enableRectCornner = true
        self.shadowView._cornerRadius = 20
        self.shadowView._rectCornner = [.topLeft,.topRight,.bottomLeft,.bottomRight]
        self.shadowView._shadowPosition = [.left,.top,.right,.bottom]
        self.shadowView._shadowColor = UIColor.black.withAlphaComponent(0.3)
        self.shadowView._shadowRadius = 10
        
        self.leftRightShadowView._enableRectCornner = false
        self.leftRightShadowView._shadowPosition = [.left,.right]
        self.leftRightShadowView._shadowColor = UIColor.black.withAlphaComponent(0.3)
        self.leftRightShadowView._shadowRadius = 10
        
    }
}

