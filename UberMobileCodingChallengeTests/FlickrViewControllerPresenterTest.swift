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

    var view: FlikrImageSearchViewSpy!
    var networkManager: NetworkManagerProtocolSpy!
    var flickrViewControllerPresenter: FlickrSearchViewControllerPresenter!
    
    override func setUp() {
        view = FlikrImageSearchViewSpy()
        networkManager = NetworkManagerProtocolSpy()
        flickrViewControllerPresenter = FlickrSearchViewControllerPresenter(view: view, networkManager: networkManager)
    }

    override func tearDown() {
        view = nil
        networkManager = nil
        flickrViewControllerPresenter = nil
    }
    
    func testFetchFlikrImagesSuccess() {
        networkManager.images = [FlickrImage].init()
        flickrViewControllerPresenter.fetchFlikrImages(text: "")
        XCTAssertTrue(networkManager.isGetFlikrImageCalled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.view.isImageFetchedCalled)
        }
    }

    func testFetchFlikrImagesFailed() {
        networkManager.errorString = "Unable to download image"
        flickrViewControllerPresenter.fetchFlikrImages(text: "")

        XCTAssertTrue(networkManager.isGetFlikrImageCalled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.view.isUnableToFetchImagesCalled)
        }

    }
}
