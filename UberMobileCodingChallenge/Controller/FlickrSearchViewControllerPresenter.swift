//
//  FlickrSearchViewControllerPresenter.swift
//  UberMobileCodingChallenge
//
//  Created by Anand Mishra on 24/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import Foundation

class FlickrSearchViewControllerPresenter {
    weak var view: FlickrImageSearchView?
    var networkManager: NetworkManagerProtocol
    var flickrImages: [FlickrImage] = [FlickrImage]()
    
    init(view: FlickrImageSearchView, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func fetchFlickrImages(text: String){
        let page = flickrImages.count/10
        networkManager.getFlickrImage(page: page, text: text) { (flickr_Images, error) in
            
            DispatchQueue.main.async {
                if let errorString = error {
                    self.view?.unableToFetchImages(errorString: errorString)
                } else {
                    if let flickrImages = flickr_Images {
                        self.flickrImages = self.flickrImages + flickrImages
                    }
                    self.view?.imageFetched()
                }
            }
        }
    }
}
