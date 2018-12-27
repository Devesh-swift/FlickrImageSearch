//
//  MovieEndPoint.swift
//  UberMobileCodingChallenge
//
//  Created by Anand Mishra on 23/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
    case dev
}

public enum FlickrImageApi {
    case newFlickrImages(page: Int, text: String)
    case downloadImage(flickrImage: FlickrImage)
}

extension FlickrImageApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.flickr.com/services/rest/"
        case .dev: return "https://api.flickr.com/services/rest/"
        }
    }
    
    var baseURL: URL {
        switch self {
        case .newFlickrImages( _):
            guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
            return url
        case .downloadImage(let flickrImage):
            guard let url = URL(string: "http://farm\(flickrImage.farm).static.flickr.com/") else { fatalError("baseURL could not be configured.")}
            return url
        }
    }
    
    var path: String {
        switch self {
        case .newFlickrImages( _):
            return ""
        case .downloadImage(let flickrImage):
            return "\(flickrImage.server)/\(flickrImage.id)_\(flickrImage.secret).jpg"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .newFlickrImages(let page, let text):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["method": "flickr.photos.search",
                                                      "api_key": NetworkManager.FlikrAPIKey,
                                                      "format": "json",
                                                      "nojsoncallback": "1",
                                                      "safe_search": "1",
                                                      "text": text,
                                                      "page": page])
        case .downloadImage( _):
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
