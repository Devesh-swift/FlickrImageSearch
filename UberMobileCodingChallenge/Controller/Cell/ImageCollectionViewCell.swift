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
    
    func setupData(flickrImage: FlickrImage) {
        self.flickrImage = flickrImage
        if let imageFromCache = imageCache.object(forKey: "\(flickrImage.server)/\(flickrImage.id)_\(flickrImage.secret).jpg" as NSString) {
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
                        imageCache.setObject( imageToCache, forKey: "\(flickrImage.server)/\(flickrImage.id)_\(flickrImage.secret).jpg" as NSString)
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
