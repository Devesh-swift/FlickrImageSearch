//
//  FlickrImageViewSpy.swift
//  UberMobileCodingChallengeTests
//
//  Created by Anand Mishra on 27/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import XCTest
@testable import UberMobileCodingChallenge


class FlickrImageViewSpy: FlickrImageView {

    var isSetupImageCalled = false

    func setupImage(image: UIImage) {
        isSetupImageCalled = true
    }
}
