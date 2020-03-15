//
//  SFWebImageMakerHelperTest.swift
//  SFImageMakerTests
//
//  Created by Jiang on 2020/3/14.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import XCTest

class WebImageFakeMananger:NSObject,SFWebImageManagerDelegate{
    var memCache = [String:UIImage]()
    var diskCache = [String:UIImage]()
    func download(for url: URL, completed: @escaping SFWebImageCompleteHandler) {
        DispatchQueue.global().async{
            Thread.sleep(forTimeInterval: 0.5)
            completed(UIImage.init(), url, nil)
        }
    }
    
    func key(for url: URL, identifier: String?) -> String {
        return identifier == nil ? url.absoluteString : url.absoluteString + identifier!
    }
    
    func memeryCache(forKey key: String) -> UIImage? {
        return self.memCache[key]
    }
    
    func saveMemeryCache(_ image: UIImage, forKey key: String) {
        DispatchQueue.main.async {
            self.memCache[key] = image
        }
    }
    
    func saveDiskCache(_ image: UIImage, forKey key: String, completed: ((Error?) -> Void)? = nil) {
        DispatchQueue.global().async{
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.diskCache[key] = image
                completed?(nil)
            }
        }
    }
    func diskCache(forKey key: String, completed: ((UIImage?, Error?) -> Void)? = nil) {
        DispatchQueue.global().async{
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                if let image = self.diskCache[key]{
                    completed?(image,nil)
                }else{
                    completed?(nil,NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"no disk image"]))
                }
            }
        }
    }
}
class SFWebImageMakerHelperTest: XCTestCase {
    let fakeManager = WebImageFakeMananger()
    var helper: SFWebImageMakerHelper!
    var noIdentifierKey: String!
    var identifierKey: String!
    override func setUp() {
        let url = URL.init(string: "https://www.test.com/image.png")
        let shadow = SFShadowImageMaker.init()
        shadow.position = .all
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 20
        helper = SFWebImageMakerHelper.init(url: url, processors: [SFBlockImageMaker.circle(),shadow])
        helper.delegate = fakeManager
        noIdentifierKey = fakeManager.key(for: helper.url, identifier: nil)
        identifierKey = fakeManager.key(for: helper.url, identifier: helper.identifier)
    }
    
    override func tearDown() {
        fakeManager.memCache = [:]
        fakeManager.diskCache = [:]
    }
    
    func testCacheOnlyStoreResultImage() {
        helper.saveOption = [.resultMemery,.resultDisk]
        var exception = self.expectation(description: "")
        helper.prcoess { (image, url, error) in
            if let image = image{
                XCTAssert(image.size != CGSize.zero)
            }
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
        // wait for disk save
        exception = self.expectation(description: "")
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssert(fakeManager.memeryCache(forKey: noIdentifierKey) == nil)
        XCTAssert(fakeManager.diskCache[noIdentifierKey] == nil)
 
        XCTAssert(fakeManager.memeryCache(forKey: identifierKey) != nil)
        XCTAssert(fakeManager.diskCache[identifierKey] != nil)
    }
    
    func testCacheOnlyStoreOriginalImage() {
        helper.saveOption = [.originalMemery,.originalDisk]
        var exception = self.expectation(description: "")
        helper.prcoess { (image, url, error) in
            if let image = image{
                XCTAssert(image.size != CGSize.zero)
            }
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
        // wait for disk save
        exception = self.expectation(description: "")
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssert(fakeManager.diskCache[noIdentifierKey] != nil)
        XCTAssert(fakeManager.memeryCache(forKey: noIdentifierKey) != nil)
        XCTAssert(fakeManager.diskCache[identifierKey] == nil)
        XCTAssert(fakeManager.memeryCache(forKey: identifierKey) == nil)
    }
    func testCacheStoreInAll() {
        helper.saveOption = .all
        var exception = self.expectation(description: "")
        helper.prcoess { (image, url, error) in
            if let image = image{
                XCTAssert(image.size != CGSize.zero)
            }
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 3, handler: nil)
        // wait for disk save
        exception = self.expectation(description: "")
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssert(fakeManager.diskCache[noIdentifierKey] != nil)
        XCTAssert(fakeManager.diskCache[identifierKey] != nil)

        XCTAssert(fakeManager.memeryCache(forKey: noIdentifierKey) != nil)
        XCTAssert(fakeManager.memeryCache(forKey: identifierKey) != nil)
    }
    func testWhileOriginalInDiskCache(){
        helper.saveOption = .all
        self.fakeManager.diskCache[noIdentifierKey] = UIImage.init()
        var exception = self.expectation(description: "")
        helper.prcoess { (image, url, error) in
            if let image = image{
                XCTAssert(image.size != CGSize.zero)
            }
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 3, handler: nil)
        // wait for disk save
        exception = self.expectation(description: "")
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssert(fakeManager.diskCache[noIdentifierKey] != nil)
        XCTAssert(fakeManager.diskCache[identifierKey] != nil)

        XCTAssert(fakeManager.memeryCache(forKey: noIdentifierKey) != nil)
        XCTAssert(fakeManager.memeryCache(forKey: identifierKey) != nil)
    }
    
    func testWhileResultInDiskCache(){
        helper.saveOption = .all
        self.fakeManager.diskCache[identifierKey] = UIImage.init()
        var exception = self.expectation(description: "")
         helper.prcoess { (image, url, error) in
             if let image = image{
                 XCTAssert(image.size == CGSize.zero)
             }
             exception.fulfill()
         }
         self.waitForExpectations(timeout: 3, handler: nil)
         // wait for disk save
         exception = self.expectation(description: "")
         DispatchQueue.global().async {
             Thread.sleep(forTimeInterval: 1)
             exception.fulfill()
         }
         self.waitForExpectations(timeout: 2, handler: nil)

        XCTAssert(fakeManager.diskCache[identifierKey] != nil)
        XCTAssert(fakeManager.memeryCache(forKey: identifierKey) != nil)
    }
    
    func testWhileOriginalInMemeryCache(){
        helper.saveOption = .all
        self.fakeManager.memCache[noIdentifierKey] = UIImage.init()
        var exception = self.expectation(description: "")
        helper.prcoess { (image, url, error) in
            if let image = image{
                XCTAssert(image.size != CGSize.zero)
            }
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 3, handler: nil)
        // wait for disk save
        exception = self.expectation(description: "")
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssert(fakeManager.memeryCache(forKey: identifierKey) != nil)
    }
    
    func testWhileResultInMemeryCache(){
        helper.saveOption = .all
        self.fakeManager.memCache[identifierKey] = UIImage.init()
        var exception = self.expectation(description: "")
         helper.prcoess { (image, url, error) in
             if let image = image{
                 XCTAssert(image.size == CGSize.zero)
             }
             exception.fulfill()
         }
         self.waitForExpectations(timeout: 3, handler: nil)
         // wait for disk save
         exception = self.expectation(description: "")
         DispatchQueue.global().async {
             Thread.sleep(forTimeInterval: 1)
             exception.fulfill()
         }
         self.waitForExpectations(timeout: 2, handler: nil)
        XCTAssert(fakeManager.memeryCache(forKey: identifierKey) != nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
