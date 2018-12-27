//
//  FlickrViewControllerPresenterTest.swift
//  UberMobileCodingChallengeTests
//
//  Created by Anand Mishra on 26/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import XCTest
@testable import UberMobileCodingChallenge


class FlickrViewControllerPresenterTest: XCTestCase {

    var view: FlickrImageSearchViewSpy!
    var networkManager: NetworkManagerProtocolSpy!
    var flickrViewControllerPresenter: FlickrSearchViewControllerPresenter!
    
    override func setUp() {
        view = FlickrImageSearchViewSpy()
        networkManager = NetworkManagerProtocolSpy()
        flickrViewControllerPresenter = FlickrSearchViewControllerPresenter(view: view, networkManager: networkManager)
    }

    override func tearDown() {
        view = nil
        networkManager = nil
        flickrViewControllerPresenter = nil
    }
    
    func testFetchFlickrImagesSuccess() {
        networkManager.images = [FlickrImage].init()
        flickrViewControllerPresenter.fetchFlickrImages(text: "")
        XCTAssertTrue(networkManager.isGetFlickrImageCalled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.view.isImageFetchedCalled)
        }
    }

    func testFetchFlickrImagesFailed() {
        networkManager.errorString = "Unable to download image"
        flickrViewControllerPresenter.fetchFlickrImages(text: "")

        XCTAssertTrue(networkManager.isGetFlickrImageCalled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.view.isUnableToFetchImagesCalled)
        }

    }
}
