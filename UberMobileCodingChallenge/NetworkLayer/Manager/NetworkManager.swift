//
//  NetworkManager.swift
//  UberMobileCodingChallenge
//
//  Created by Anand Mishra on 23/12/18.
//  Copyright © 2018 OrgID. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}
protocol NetworkManagerProtocol {
    
    func getFlikrImage(page: Int, text: String, completion: @escaping (_ flikrImages: [FlickrImage]?,_ error: String?)->())
    func downloadImage(flickrImage: FlickrImage, completion: @escaping (_ imageData: Data?,_ error: String?)->())
    
    func cancelDownloading()
}
struct NetworkManager: NetworkManagerProtocol {
   
    
    static let environment : NetworkEnvironment = .production
    static let FlikrAPIKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    var router: Router<FlickrImageApi>!
    
    init(_ router: Router<FlickrImageApi> = Router<FlickrImageApi>()) {
        self.router = router
    }
    
    func downloadImage(flickrImage: FlickrImage, completion: @escaping (Data?, String?) -> ()) {
        router.request(.downloadImage(flickrImage: flickrImage)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    completion(responseData,nil)
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getFlikrImage(page: Int, text: String, completion: @escaping (_ flikrImages: [FlickrImage]?,_ error: String?)->()){
        router.request(.newFlickrImages(page: page, text: text)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(FlikrImagesResponse.self, from: responseData)
                        completion(apiResponse.photos.flickrImages,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func cancelDownloading() {
        router.cancel()
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
