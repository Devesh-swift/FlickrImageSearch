//
//  ViewController.swift
//  UberMobileCodingChallenge
//
//  Created by Anand Mishra on 23/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import UIKit
import Foundation

let imageCache = NSCache<NSString, UIImage>()

protocol FlikrImageSearchView: class {
    func imageFetched()
    func unableToFetchImages(errorString: String)
}

class FlickrImageSearchViewController: UIViewController {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var flikrImageCollectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    
    let reuseIdentifier:String = "FlickrCell"
    var isWating = false
    var presenter:FlickrSearchViewControllerPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FlickrSearchViewControllerPresenter(view: self)
        self.messageLabel.text = "Please type words to search images."
    }
    
    func loadNextSet() {
        self.presenter.fetchFlikrImages(text: searchbar.text!)
    }
}

extension FlickrImageSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.presenter.flickrImages.removeAll()
        self.presenter.fetchFlikrImages(text: searchbar.text!)
        self.acitivityIndicator.startAnimating()
        imageCache.removeAllObjects()
    }
}

extension FlickrImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.flickrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
       cell.setupData(flickrImage: self.presenter.flickrImages[indexPath.row])
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3-2, height: UIScreen.main.bounds.width/3-2)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.presenter.flickrImages.count - 1 && !isWating {
            isWating = true
            loadNextSet()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterIdentifier", for: indexPath as IndexPath)
        
        if let activityIndicater = footerView.viewWithTag(100) as? UIActivityIndicatorView {
            if isWating {
                activityIndicater.startAnimating()
            } else {
                activityIndicater.stopAnimating()
            }
        }
        
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let flickrImageViewController:FlickrImageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FlickrImageViewController") as! FlickrImageViewController
        flickrImageViewController.flickrImage = self.presenter.flickrImages[indexPath.row]
        self.navigationController?.pushViewController(flickrImageViewController, animated: true)
        
    }
}


extension FlickrImageSearchViewController: FlikrImageSearchView {
    func imageFetched() {
        if presenter.flickrImages.count == 0 {
                self.messageLabel.text = "Unable to load images. Please try again."
        } else {
            self.messageLabel.text = ""
        }
        self.acitivityIndicator.stopAnimating()
        self.flikrImageCollectionView.reloadData()
        isWating = false

    }
    
    func unableToFetchImages(errorString: String) {
        self.acitivityIndicator.stopAnimating()
        self.flikrImageCollectionView.reloadData()
        isWating = false
        
        if presenter.flickrImages.count == 0 {
            self.messageLabel.text = errorString
        } else {
            let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
            self.present(alertController, animated: true)
        }
        
    }
}
