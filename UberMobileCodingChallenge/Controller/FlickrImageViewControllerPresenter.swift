//
//  FlickrImageVIewControllerPresenter.swift
//  UberMobileCodingChallenge
//
//  Created by Anand Mishra on 27/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import Foundation
import UIKit


class FlickrImageViewControllerPresenter {
    
    weak var view: FlickrImageView?
    var networkManager: NetworkManagerProtocol
    
    init(view: FlickrImageView, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.view = view
        self.networkManager = networkManager
    }
    
    
    fileprivate func flickrImagekey(_ flickrImage: FlickrImage) -> NSString {
        return "\(flickrImage.server)/\(flickrImage.id)_\(flickrImage.secret).jpg" as NSString
    }
    
    func loadImage(flickrImage: FlickrImage, _imageCache: NSCache<NSString, UIImage>) {
        if let imageFromCache = _imageCache.object(forKey: flickrImagekey(flickrImage)) {
            self.view?.setupImage(image: imageFromCache)
            return
        }
        
        self.view?.setupImage(image: UIImage.init(named: "placeholder")!)
        networkManager.downloadImage(flickrImage: flickrImage) { (data, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.view?.setupImage(image: UIImage.init(named: "placeholder")!)
                } else {
                    if let imageData = data ,let imageToCache = UIImage(data: imageData) {
                        _imageCache.setObject( imageToCache, forKey: self.flickrImagekey(flickrImage))
                        self.view?.setupImage(image: imageToCache)
                    }
                }
            }
        }
    }
}
