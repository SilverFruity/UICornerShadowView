//
//  SFImageMakerTests.swift
//  SFImageMakerTests
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import XCTest
import SFImageMaker

class SFImageMakerTests: XCTestCase {
    let shadow = SFShadowImageMaker.init()
    let border = SFBorderImageMaker.init()
    let rectCorner = SFCornerImageMaker.init()
    override func setUp() {
        rectCorner.radius = 20
        rectCorner.position = .allCorners
        shadow.position = .all
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 20
        border.color = UIColor.black
        border.width = 5
        border.cornerMaker = rectCorner
    }
    override func tearDown() {
        
    }
    func testDependenciesIdentifier(){
        let noDependencies = SFColorImageMaker.init(color: UIColor.white)
        let colorMaker = SFColorImageMaker.init(color: UIColor.white)
        colorMaker.dependencies.addObjects(from: [rectCorner,border,shadow])
        var result = noDependencies.identifier() + rectCorner.identifier() + border.identifier() + shadow.identifier()
        XCTAssert(SFImageMakerManager.shared().identifier(with: colorMaker, processors: nil) == result, result)
        
        colorMaker.dependencies = NSMutableArray.init()
        colorMaker.dependencies.add(SFBlurImageMaker.lightEffect())
        let processors:[SFImageProcessor] = [rectCorner,border,shadow]
        result = noDependencies.identifier() + SFBlurImageMaker.lightEffect().identifier() + processors.reduce("", {$0 + $1.identifier()})
        XCTAssert(SFImageMakerManager.shared().identifier(with: colorMaker, processors: processors) == result, result)
    }
    func testPerformanceExample() {
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
                border.cornerMaker = rectCorner
                var maxValue = rectCorner.radius > (border.width + 1) && rectCorner.isEnable ? rectCorner.radius : border.width + 1
                maxValue = shadow.shadowBlurRadius > maxValue ? shadow.shadowBlurRadius : maxValue
                let size = CGSize.init(width: maxValue * 2, height: maxValue * 2)
//                let size = CGSize.init(width: 400, height: 100)
                let image = SFImageMakerManager.shared().start(with: SFColorImageMaker(color: UIColor.white, size: size), processors: [rectCorner,border,shadow])
                if let cgimg = image.cgImage{
                    cost += cgimg.height * cgimg.width * (cgimg.bitsPerPixel / cgimg.bitsPerComponent)
                }
            }
            // width:400 height:100 1000次 耗时 7.5s 缓存大小715MB
            // 仅使用圆角大小、阴影、边框的大小计算宽高时 1000次 耗时 1.01s 缓存大小29MB
            print("\(cost / (1024 * 1024))MB")
            cost = 0
        }
    }

}
