//
//  SFShadowImageMakerTests.swift
//  SFImageMakerTests
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import XCTest

class SFShadowImageMakerTests: XCTestCase {
    let shadow = SFShadowImageMaker.init()
    override func setUp() {
        shadow.shadowBlurRadius = 20
        shadow.shadowOffset = CGSize.zero
        shadow.shadowColor = UIColor.black
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

}
