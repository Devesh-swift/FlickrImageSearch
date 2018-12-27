//
//  FlickrImageViewController.swift
//  UberMobileCodingChallenge
//
//  Created by Anand Mishra on 24/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import UIKit

protocol FlickrImageView: class{
    func setupImage(image: UIImage)
}

class FlickrImageViewController: UIViewController, FlickrImageView {
    
    @IBOutlet weak var flickrImageView: UIImageView!
    
    var flickrImage: FlickrImage!
    var presenter:FlickrImageViewControllerPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FlickrImageViewControllerPresenter(view: self)
        presenter.loadImage(flickrImage: flickrImage, _imageCache: imageCache)
    }
    
    func setupImage(image: UIImage) {
        self.flickrImageView.image = image
    }
}
