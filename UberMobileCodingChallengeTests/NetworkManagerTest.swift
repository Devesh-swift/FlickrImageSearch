//
//  NetworkManagerTest.swift
//  UberMobileCodingChallengeTests
//
//  Created by Anand Mishra on 27/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import XCTest
@testable import UberMobileCodingChallenge


class NetworkManagerTest: XCTestCase {
    var router: RouterSpy<FlickrImageApi>!
    var networkManager: NetworkManager!
    
    override func setUp() {
        router = RouterSpy<FlickrImageApi>()
        networkManager = NetworkManager(router)
    }
    
    func testDownloadImageSuccess() {
        let flickrImage = FlickrImage(id: "1", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title")

        self.router.data = UIImage.init(named: "placeholder")!.pngData()
        self.router.response = HTTPURLResponse.init(url: URL(string: "https://www.google.com/")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        networkManager.downloadImage(flickrImage: flickrImage) { (data, errorString) in
            
            XCTAssertEqual(UIImage.init(named: "placeholder")!.pngData(), data)
        }
        XCTAssertTrue(self.router.isRequestCalled)
    }
    
    func testDownloadImageFailedWithNoImageData() {
        let flickrImage = FlickrImage(id: "1", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title")
        
        self.router.response = HTTPURLResponse.init(url: URL(string: "https://www.google.com/")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        networkManager.downloadImage(flickrImage: flickrImage) { (data, errorString) in
            XCTAssertEqual(errorString, "Response returned with no data to decode.")
        }
        XCTAssertTrue(self.router.isRequestCalled)
    }
    
    func testDownloadImageFailed() {
        let flickrImage = FlickrImage(id: "1", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title")
        
        self.router.error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Please check your network connection."])
        
        networkManager.downloadImage(flickrImage: flickrImage) { (data, errorString) in
            XCTAssertEqual(errorString, "Please check your network connection.")
        }
        XCTAssertTrue(self.router.isRequestCalled)
    }
    
    func testDownloadImageFailedDueToNetwork() {
        let flickrImage = FlickrImage(id: "1", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title")
        
        self.router.response = HTTPURLResponse.init(url: URL(string: "https://www.google.com/")!, statusCode: 500, httpVersion: nil, headerFields: nil)

        networkManager.downloadImage(flickrImage: flickrImage) { (data, errorString) in
            XCTAssertEqual(errorString, "You need to be authenticated first.")
        }
        XCTAssertTrue(self.router.isRequestCalled)
    }
    
    func testGetFlickrImageSuccess() {
        
        self.router.data = "{\"photos\":{\"page\":1,\"pages\":156284,\"perpage\":1,\"total\":\"156284\",\"photo\":[{\"id\":\"45761826554\",\"owner\":\"58679537@N00\",\"secret\":\"9527bbeabc\",\"server\":\"4828\",\"farm\":5,\"title\":\"Cats guarding me in the bathroom!\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0}]},\"stat\":\"ok\"}".data(using: .utf8)
        self.router.response = HTTPURLResponse.init(url: URL(string: "https://www.google.com/")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        networkManager.getFlickrImage(page: 0, text: "test") { (flickrimage, error) in
            
        }
        XCTAssertTrue(self.router.isRequestCalled)
    }
    
    func testGetFlickrImageFailedWithNoImageData() {
        self.router.response = HTTPURLResponse.init(url: URL(string: "https://www.google.com/")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        networkManager.getFlickrImage(page: 0, text: "test") { (flickrimage, error) in
            XCTAssertEqual(error, "Response returned with no data to decode.")
        }
        XCTAssertTrue(self.router.isRequestCalled)
    }
    
    func testGetFlickrImageFailed() {
        self.router.error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Please check your network connection."])
        
        networkManager.getFlickrImage(page: 0, text: "test") { (flickrimage, error) in
            XCTAssertEqual(error, "Please check your network connection.")
        }
        XCTAssertTrue(self.router.isRequestCalled)
    }
    
    func testGetFlickrImageFailedDueToNetwork() {
        self.router.response = HTTPURLResponse.init(url: URL(string: "https://www.google.com/")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        networkManager.getFlickrImage(page: 0, text: "test") { (flickrimage, error) in
            XCTAssertEqual(error, "You need to be authenticated first.")
        }
        
        XCTAssertTrue(self.router.isRequestCalled)
    }
    
    func testCancelDownloading() {
        networkManager.cancelDownloading()
        XCTAssertTrue(self.router.isCancedCalled)
    }

}
