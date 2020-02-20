//
//  SFBorderImageMakerTests.swift
//  SFImageMakerTests
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import XCTest

class SFBorderImageMakerTests: XCTestCase {
    let border = SFBorderImageMaker.init()
    override func setUp() {
        border.width = 20
        border.color = UIColor.black
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

}
