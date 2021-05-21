//
//  ViewController3.swift
//  UICornerShadowView
//
//  Created by APPLE on 2021/5/21.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

import UIKit
import SFImageMaker
class ViewController3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIColor.red.sf_flowWithSize(CGSize.zero).corner(1, UIRectCorner.allCorners).image()
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
