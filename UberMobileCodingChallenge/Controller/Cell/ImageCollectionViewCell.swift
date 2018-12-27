//
//  ImageCollectionViewCell.swift
//  UberMobileCodingChallenge
//
//  Created by Anand Mishra on 24/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filkerImageView: UIImageView!
    let networkManager = NetworkManager()
    var flickrImage: FlickrImage!
    
    fileprivate func flickrImageKey(_flickrImage: FlickrImage) -> NSString {
        return "\(_flickrImage.server)/\(_flickrImage.id)_\(_flickrImage.secret).jpg" as NSString
    }
    
    func setupData(flickrImage: FlickrImage) {
        self.flickrImage = flickrImage
        if let imageFromCache = imageCache.object(forKey: flickrImageKey(_flickrImage: flickrImage)) {
            self.filkerImageView.image = imageFromCache
            return
        }
        
        self.filkerImageView.image = UIImage.init(named: "placeholder")
        networkManager.downloadImage(flickrImage: flickrImage) { (data, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.filkerImageView.image = UIImage.init(named: "placeholder")
                } else {
                    if let imageData = data ,let imageToCache = UIImage(data: imageData) {
                        imageCache.setObject( imageToCache, forKey: self.flickrImageKey(_flickrImage: flickrImage))
                        if self.flickrImage == flickrImage {
                            self.filkerImageView.image = imageToCache
                        }
                    }
                }
            }
        }
    }
    
    func cancelDownload() {
        networkManager.cancelDownloading()
    }
}
