//
//  FlickrImageSearchViewControllerTests.swift
//  UberMobileCodingChallengeTests
//
//  Created by Anand Mishra on 27/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import UIKit
import XCTest
@testable import UberMobileCodingChallenge

class FlickrImageSearchViewControllerTests: XCTestCase {
    
    
    var viewController: FlickrImageSearchViewController!
    
    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navigationController.topViewController as? FlickrImageSearchViewController
        
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(viewController.view)
    }
    
    func testCollectionViewCellsIsDisplayedWithMatchingImage() {

        let fakeImagesName = [FlickrImage(id: "1", owner: "", secret: "", server: "", farm: 1, title: "")]
        viewController.presenter.flickrImages = fakeImagesName
        

        viewController.flikrImageCollectionView.reloadData()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        

        let cells = viewController?.flikrImageCollectionView.visibleCells as! [ImageCollectionViewCell]
        XCTAssertEqual(cells.count, fakeImagesName.count, "Cells count should match array.count")
    }
}
