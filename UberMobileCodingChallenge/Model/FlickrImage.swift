//
//  FlickrImage.swift
//  UberMobileCodingChallenge
//
//  Created by Anand Mishra on 24/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import Foundation

struct FlickrImagesResponse {
    let photos: FlickrPhoto
}

extension FlickrImagesResponse: Decodable {

    private enum FlickrImagesResponseCodingKeys: String, CodingKey {
        case photos = "photos"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FlickrImagesResponseCodingKeys.self)
        
        photos = try container.decode(FlickrPhoto.self, forKey: .photos)
    }
}

struct FlickrPhoto {
    let page: Int
    let numberOfResults: Int
    let numberOfPages: Int
    let flickrImages: [FlickrImage]
}

extension FlickrPhoto: Decodable {
    
    private enum FlickrImageResponseCodingKeys: String, CodingKey {
        case page = "page"
        case numberOfResults = "perpage"
        case numberOfPages = "pages"
        case flickrImages = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FlickrImageResponseCodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        flickrImages = try container.decode([FlickrImage].self, forKey: .flickrImages)
        
    }
}


public struct FlickrImage {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
}

extension FlickrImage: Decodable {
    
    enum FlickrImageCodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
    }
    
    
    public init(from decoder: Decoder) throws {
        let flickrImageContainer = try decoder.container(keyedBy: FlickrImageCodingKeys.self)
        
        id = try flickrImageContainer.decode(String.self, forKey: .id)
        owner = try flickrImageContainer.decode(String.self, forKey: .owner)
        secret = try flickrImageContainer.decode(String.self, forKey: .secret)
        server = try flickrImageContainer.decode(String.self, forKey: .server)
        farm = try flickrImageContainer.decode(Int.self, forKey: .farm)
        title = try flickrImageContainer.decode(String.self, forKey: .title)
    }
}


extension FlickrImage: Equatable {
    
    public static func == (lhs: FlickrImage, rhs: FlickrImage) -> Bool {
        return lhs.farm == rhs.farm &&
            lhs.server == rhs.server &&
            lhs.secret == rhs.secret &&
            lhs.id == rhs.id
    }
}




