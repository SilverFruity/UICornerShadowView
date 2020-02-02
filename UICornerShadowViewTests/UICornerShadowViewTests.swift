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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
