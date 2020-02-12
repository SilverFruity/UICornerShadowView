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
    let shadow = SFShadow.init()
    let border = SFBorder.init()
    let rectCorner = SFRectCorner.init()
    
    override func setUp() {
        shadow.shadowBlurRadius = 20
        shadow.shadowOffset = CGSize.zero
        shadow.shadowColor = UIColor.black
        border.width = 20
        border.color = UIColor.black
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testAllShadowWithNegativeOffset(){
        shadow.position = .all
        let rect = shadow.viewRect(for: CGSize(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: -20, y: -20, width: 240, height: 240),rect.debugDescription)
    }
    func testAllShadowWithPositiveOffset(){
        shadow.position = .all
        let rect = shadow.viewRect(for: CGSize(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: -20, y: -20, width: 240, height: 240),rect.debugDescription)
    }
    func testHideLeftShadow(){
        shadow.position = [.top,.bottom,.right]
        let rect = shadow.viewRect(for: CGSize(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: 0, y: -20, width: 220, height: 240),rect.debugDescription)
    }
    func testHideRightShadow(){
        shadow.position = [.top,.bottom,.left]
        let rect = shadow.viewRect(for: CGSize(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: -20, y: -20, width: 220, height: 240),rect.debugDescription)
    }

    func testHideVerticalShadow(){
        shadow.position = [.left,.right]
        let rect = shadow.viewRect(for: CGSize(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: -20, y: 0, width: 240, height: 200),rect.debugDescription)
    }
    
    func testHideTopShadow(){
        shadow.position = [.left,.right,.bottom]
        let rect = shadow.viewRect(for: CGSize(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: -20, y: 0, width: 240, height: 220),rect.debugDescription)
    }
    func testHideBottomShadow(){
        shadow.position = [.left,.right,.top]
        let rect = shadow.viewRect(for: CGSize(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: -20, y: -20, width: 240, height: 220),rect.debugDescription)
    }
    
    func testAllBorder(){
        border.position = [.left,.right,.top,.bottom]
        let rect = border.strokeRect(with: CGSize.init(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: 10, y: 10, width: 180, height: 180),rect.debugDescription)
    }
    func testHideLeftBorder(){
        border.position = [.right,.top,.bottom]
        let rect = border.strokeRect(with: CGSize.init(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: -10, y: 10, width: 200, height: 180),rect.debugDescription)
    }
    func testHideRightBorder(){
        border.position = [.left,.top,.bottom]
        let rect = border.strokeRect(with: CGSize.init(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: 10, y: 10, width: 200, height: 180),rect.debugDescription)
    }
    
    func testHideTopBorder(){
        border.position = [.left,.right,.bottom]
        let rect = border.strokeRect(with: CGSize.init(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: 10, y: -10, width: 180, height: 200),rect.debugDescription)
    }
    func testHideBottomBorder(){
        border.position = [.left,.right,.top]
        let rect = border.strokeRect(with: CGSize.init(width: 200, height: 200))
        XCTAssertTrue(rect == CGRect(x: 10, y: 10, width: 180, height: 200),rect.debugDescription)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        
        self.measure {
            var cost: Int = 0
            for _ in (0...1000){
                rectCorner.radius = CGFloat(Int.random(in: 0..<10))
                let cornerPositions: [UIRectCorner] = [.topLeft,.topRight,.bottomLeft,.bottomRight]
                var cornerResult = [UIRectCorner]()
                var cornerCount = Int.random(in: 0..<4)
                while cornerCount >= 0 {
                    cornerResult.append(cornerPositions[Int.random(in: 0..<4)])
                    cornerCount -= 1
                }
                rectCorner.position = UIRectCorner.init(cornerResult)
                
                let shadowPositions: [UIShadowPostion] = [.left,.top,.right,.bottom]
                var shadowResult = [UIShadowPostion]()
                var shadowResultCount = Int.random(in: 0..<4)
                while shadowResultCount >= 0 {
                    shadowResult.append(shadowPositions[Int.random(in: 0..<4)])
                    shadowResultCount -= 1
                }
                shadow.position = UIShadowPostion.init(shadowResult)
                shadow.shadowColor = UIColor.init(red: CGFloat(Int.random(in: 0...10)) / 10, green: CGFloat(Int.random(in: 0...10)) / 10, blue: CGFloat(Int.random(in: 0...10)) / 10, alpha: 1)
                shadow.shadowBlurRadius = CGFloat(Int.random(in: 8..<20))
                border.color = UIColor.init(red: CGFloat(Int.random(in: 0...10)) / 10, green: CGFloat(Int.random(in: 0...10)) / 10, blue: CGFloat(Int.random(in: 0...10)) / 10, alpha: 1)
                border.width = CGFloat(Int.random(in: 0..<20))
                
                let borderPositions: [UIBorderPostion] = [.left,.top,.right,.bottom]
                var borderResult = [UIBorderPostion]()
                var borderCount = Int.random(in: 0..<4)
                while borderCount >= 0 {
                    borderResult.append(borderPositions[Int.random(in: 0..<4)])
                    borderCount -= 1
                }
                border.position = UIBorderPostion.init(borderResult)
                var maxValue = rectCorner.radius > (border.width + 1) && rectCorner.isEnable ? rectCorner.radius : border.width + 1
                maxValue = shadow.shadowBlurRadius > maxValue ? shadow.shadowBlurRadius : maxValue
                let size = CGSize.init(width: maxValue * 2, height: maxValue * 2)
//                let size = CGSize.init(width: 400, height: 100)
                let colorImage = SFColorImage.init(color: UIColor.white, size: size);
                UIGraphicsBeginImageContextWithOptions(colorImage.size, false, 0)
                let ctx = UIGraphicsGetCurrentContext()!
                rectCorner.process(ctx)
                colorImage.process(ctx)
                border.process(ctx, rectCorner: rectCorner)
                shadow.process(ctx)
                let image = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                if let cgimg = image.cgImage{
                    cost += cgimg.height * cgimg.width * (cgimg.bitsPerPixel / cgimg.bitsPerComponent)
                }
            }
            // width:400 height:100 1000次 耗时 7.5s 缓存大小715MB
            // -----
            // 压缩图片时: 仅使用圆角大小、阴影、边框的大小计算宽高
            // 每次生成图片:  1000次 耗时 1.01s 缓存大小29MB
            // 使用CGContext逐步绘制，只生成一次图片: 1000次 耗时 0.7s 缓存大小为29MB
            print("\(cost / (1024 * 1024))MB")
            cost = 0
        }
    }

}
