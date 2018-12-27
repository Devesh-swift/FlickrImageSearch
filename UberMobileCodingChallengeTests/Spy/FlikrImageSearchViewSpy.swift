//
//  FlikrImageSearchViewSpy.swift
//  UberMobileCodingChallengeTests
//
//  Created by Anand Mishra on 26/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import Foundation
import XCTest
@testable import UberMobileCodingChallenge


class FlikrImageSearchViewSpy: FlikrImageSearchView {
    var isImageFetchedCalled = false
    var isUnableToFetchImagesCalled = false
    
    func imageFetched() {
        isImageFetchedCalled = true
    }
    
    func unableToFetchImages(errorString: String) {
        isUnableToFetchImagesCalled = true
    }
}
