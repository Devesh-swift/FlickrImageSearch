//
//  RouterSpy.swift
//  UberMobileCodingChallengeTests
//
//  Created by Anand Mishra on 27/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import Foundation
import XCTest
@testable import UberMobileCodingChallenge


class RouterSpy<EndPoint: EndPointType>: Router<EndPoint> {
    var isRequestCalled = false
    var isCancedCalled = false
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    override func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        isRequestCalled = true
        completion(data, response, error)
    }
    
    override func cancel() {
        isCancedCalled = true
    }

}
