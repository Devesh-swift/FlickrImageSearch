//
//  FlickrImageVIewControllerPresenterTest.swift
//  UberMobileCodingChallengeTests
//
//  Created by Anand Mishra on 27/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import XCTest
import UIKit
@testable import UberMobileCodingChallenge


class FlickrImageVIewControllerPresenterTest: XCTestCase {
    
    var view: FlickrImageViewSpy!
    var networkManager: NetworkManagerProtocolSpy!
    var flickrImageViewControllerPresenter: FlickrImageViewControllerPresenter!
    
    override func setUp() {
        view = FlickrImageViewSpy()
        networkManager = NetworkManagerProtocolSpy()
        flickrImageViewControllerPresenter = FlickrImageViewControllerPresenter(view: view, networkManager: networkManager)
    }
    
    override func tearDown() {
        view = nil
        networkManager = nil
        flickrImageViewControllerPresenter = nil
    }
    
    func testLoadImagesFetchFromCacheSuccess() {
        let imageCache = NSCache<NSString, UIImage>()
        imageCache.setObject(UIImage.init(named: "placeholder")!, forKey: "server/1_secret.jpg")
        let flickrImage = FlickrImage(id: "1", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title")
        flickrImageViewControllerPresenter.loadImage(flickrImage: flickrImage, _imageCache: imageCache)
        
        XCTAssertTrue(self.view.isSetupImageCalled)
    }
    

    func testLoadImagesSuccess() {

        let imageCache = NSCache<NSString, UIImage>()
        let flickrImage = FlickrImage(id: "1", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title")
        networkManager.data = UIImage.init(named: "placeholder")!.pngData()
        flickrImageViewControllerPresenter.loadImage(flickrImage: flickrImage, _imageCache: imageCache)
        XCTAssertTrue(networkManager.isDownloadImageCalled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.view.isSetupImageCalled)
        }
    }



    func testLoadImagesFailed() {
        let imageCache = NSCache<NSString, UIImage>()
        let flickrImage = FlickrImage(id: "1", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title")
        networkManager.errorString = "Failed to load"
        flickrImageViewControllerPresenter.loadImage(flickrImage: flickrImage, _imageCache: imageCache)
        XCTAssertTrue(networkManager.isDownloadImageCalled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.view.isSetupImageCalled)
        }
    }
}

