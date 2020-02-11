//
//  UICornerShadowViewTests.swift
//  UICornerShadowViewTests
//
//  Created by Jiang on 2020/1/15.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import XCTest
@testable import UICornerShadowView

class UICornerShadowViewTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testAllShadowWithNegativeOffset(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let offset = CGSize(width: -20, height: -20)
        let radius: CGFloat = 20
        let position:UIShadowPostion = .all
        let rect = UIImage.shadowBackGroundImageRect(withViewSize: viewSize, shadowOffset: offset, shadowRadius: radius, position: position)
        XCTAssertTrue(rect == CGRect(x: -40, y: -40, width: 260, height: 260),rect.debugDescription)
    }
    func testAllShadowWithPositiveOffset(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let offset = CGSize(width: 20, height: 20)
        let radius: CGFloat = 20
        let position:UIShadowPostion = .all
        let rect = UIImage.shadowBackGroundImageRect(withViewSize: viewSize, shadowOffset: offset, shadowRadius: radius, position: position)
        XCTAssertTrue(rect == CGRect(x: -20, y: -20, width: 260, height: 260),rect.debugDescription)
    }
    func testHideLeftShadow(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let radius: CGFloat = 20
        let position:UIShadowPostion = [.top,.bottom,.right]
        let rect = UIImage.shadowBackGroundImageRect(withViewSize: viewSize, shadowOffset: CGSize.zero, shadowRadius: radius, position: position)
        XCTAssertTrue(rect == CGRect(x: 0, y: -20, width: 220, height: 240),rect.debugDescription)
    }
    func testHideRightShadow(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let radius: CGFloat = 20
        let position:UIShadowPostion = [.top,.bottom,.left]
        let rect = UIImage.shadowBackGroundImageRect(withViewSize: viewSize, shadowOffset: CGSize.zero, shadowRadius: radius, position: position)
        XCTAssertTrue(rect == CGRect(x: -20, y: -20, width: 220, height: 240),rect.debugDescription)
    }

    func testHideVerticalShadow(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let radius: CGFloat = 20
        let position:UIShadowPostion = [.left,.right]
        let rect = UIImage.shadowBackGroundImageRect(withViewSize: viewSize, shadowOffset: CGSize.zero, shadowRadius: radius, position: position)
        XCTAssertTrue(rect == CGRect(x: -20, y: 0, width: 240, height: 200),rect.debugDescription)
    }
    
    func testHideTopShadow(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let radius: CGFloat = 20
        let position:UIShadowPostion = [.left,.right,.bottom]
        let rect = UIImage.shadowBackGroundImageRect(withViewSize: viewSize, shadowOffset: CGSize.zero, shadowRadius: radius, position: position)
        XCTAssertTrue(rect == CGRect(x: -20, y: 0, width: 240, height: 220),rect.debugDescription)
    }
    func testHideBottomShadow(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let radius: CGFloat = 20
        let position:UIShadowPostion = [.left,.right,.top]
        let rect = UIImage.shadowBackGroundImageRect(withViewSize: viewSize, shadowOffset: CGSize.zero, shadowRadius: radius, position: position)
        XCTAssertTrue(rect == CGRect(x: -20, y: -20, width: 240, height: 220),rect.debugDescription)
        
    }
    
    func testAllBorder(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let width : CGFloat = 20
        let position:UIBorderPostion = [.left,.right,.top,.bottom]
        let rect = UIImage.borderConvasRect(with: viewSize, width: width, position: position)
        XCTAssertTrue(rect == CGRect(x: 10, y: 10, width: 180, height: 180),rect.debugDescription)
    }
    func testHideLeftBorder(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let width : CGFloat = 20
        let position:UIBorderPostion = [.right,.top,.bottom]
        let rect = UIImage.borderConvasRect(with: viewSize, width: width, position: position)
        XCTAssertTrue(rect == CGRect(x: -10, y: 10, width: 200, height: 180),rect.debugDescription)
    }
    func testHideRightBorder(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let width : CGFloat = 20
        let position:UIBorderPostion = [.left,.top,.bottom]
        let rect = UIImage.borderConvasRect(with: viewSize, width: width, position: position)
        XCTAssertTrue(rect == CGRect(x: 10, y: 10, width: 200, height: 180),rect.debugDescription)
    }
    
    func testHideTopBorder(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let width : CGFloat = 20
        let position:UIBorderPostion = [.left,.right,.bottom]
        let rect = UIImage.borderConvasRect(with: viewSize, width: width, position: position)
        XCTAssertTrue(rect == CGRect(x: 10, y: -10, width: 180, height: 200),rect.debugDescription)
    }
    func testHideBottomBorder(){
        let viewSize = CGSize.init(width: 200, height: 200)
        let width : CGFloat = 20
        let position:UIBorderPostion = [.left,.right,.top]
        let rect = UIImage.borderConvasRect(with: viewSize, width: width, position: position)
        XCTAssertTrue(rect == CGRect(x: 10, y: 10, width: 180, height: 200),rect.debugDescription)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        let shadowView = UICornerShadowView.init()
        self.measure {
            for _ in (0...1000){
                shadowView.backgroundColor = UIColor.init(red: CGFloat.random(in: 0...10) / 10, green: CGFloat.random(in: 0...10) / 10, blue: CGFloat.random(in: 0...10) / 10, alpha: 1)
                shadowView._enableRectCornner = true
                shadowView._cornerRadius = CGFloat(Int.random(in: 0..<10))
                let cornerPositions: [UIRectCorner] = [.topLeft,.topRight,.bottomLeft,.bottomRight]
                var cornerResult = [UIRectCorner]()
                var cornerCount = Int.random(in: 0..<4)
                while cornerCount >= 0 {
                    cornerResult.append(cornerPositions[Int.random(in: 0..<4)])
                    cornerCount -= 1
                }
                shadowView._rectCornner = UIRectCorner.init(cornerResult)
                
                let shadowPositions: [UIShadowPostion] = [.left,.top,.right,.bottom]
                var shadowResult = [UIShadowPostion]()
                var shadowResultCount = Int.random(in: 0..<4)
                while shadowResultCount >= 0 {
                    shadowResult.append(shadowPositions[Int.random(in: 0..<4)])
                    shadowResultCount -= 1
                }
                shadowView._shadowPosition = UIShadowPostion.init(shadowResult)
                shadowView._shadowColor = UIColor.init(red: CGFloat(Int.random(in: 0...10)) / 10, green: CGFloat(Int.random(in: 0...10)) / 10, blue: CGFloat(Int.random(in: 0...10)) / 10, alpha: 1)
                shadowView._shadowRadius = CGFloat(Int.random(in: 8..<20))
                shadowView._borderColor = UIColor.init(red: CGFloat(Int.random(in: 0...10)) / 10, green: CGFloat(Int.random(in: 0...10)) / 10, blue: CGFloat(Int.random(in: 0...10)) / 10, alpha: 1)
                shadowView._borderWidth = CGFloat(Int.random(in: 0..<20))
                
                let borderPositions: [UIBorderPostion] = [.left,.top,.right,.bottom]
                var borderResult = [UIBorderPostion]()
                var borderCount = Int.random(in: 0..<4)
                while borderCount >= 0 {
                    borderResult.append(borderPositions[Int.random(in: 0..<4)])
                    borderCount -= 1
                }
                shadowView._borderPosition = UIBorderPostion.init(borderResult)

                let enableRectConer = shadowView._enableRectCornner
                let radius = shadowView._cornerRadius
                let rectCornner = shadowView._rectCornner
                let shadowColor = shadowView._shadowColor
                let shadowOffset = shadowView._shadowOffset
                let shadowRadius = shadowView._shadowRadius
                let shadowPosition = shadowView._shadowPosition
                let borderWidth = shadowView._borderWidth
                let borderColor = shadowView._borderColor
                let borderPosition = shadowView._borderPosition
                
                var maxValue = radius > (borderWidth + 1) && enableRectConer ? radius : borderWidth + 1
                maxValue = shadowRadius > maxValue ? shadowRadius : maxValue
                let size = CGSize.init(width: maxValue * 2, height: maxValue * 2)
                var image = UIImage.init(color: UIColor.white, size: size)
//                var image = UIImage.init(color: UIColor.white, size: CGSize.init(width: 400, height: 100))
                if enableRectConer{
                    image = image.cornerImage(withRoundingCorners: rectCornner, radius: radius)
                }
                if borderColor != UIColor.clear && borderWidth != 0{
                    image = image.borderPathImage(withRoundingCorners: rectCornner, radius: enableRectConer ? radius : 0, width: borderWidth, position: borderPosition, stroke: borderColor)
                }
                if shadowColor != UIColor.clear && shadowRadius != 0{
                    image = image.shadow(shadowOffset, radius: shadowRadius, color: shadowColor, shadowPositoin: shadowPosition)
                }
                image = image.resizableImageCenterMode()
                CustomRenderCache.default.setObject(image, forKey: shadowView.identifier())
            }
            // width:400 height:100 1000次 耗时 7.5s 缓存大小712MB
            // 仅使用圆角大小、阴影、边框的大小计算宽高时 1000次 耗时 1.4s 缓存大小29MB
            print("\(CustomRenderCache.default.cacheCost() / (1024 * 1024))MB")
            CustomRenderCache.default.clear()
        }
    }

}
