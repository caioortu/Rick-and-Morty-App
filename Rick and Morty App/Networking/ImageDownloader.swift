//
//  ImageDownloader.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import UIKit

protocol ImageDownloaderType {
    var network: NetworkHandler { get }
    
    func loadImage(url: String, completion: @escaping (Result<UIImage, NSError>) -> Void)
}

struct ImageDownloader: ImageDownloaderType {
    static let error = NSError(domain: "image error",
                               code: -1,
                               userInfo: ["Description": "Failed to get image from data"])
    
    var network: NetworkHandler = Network()
    
    func loadImage(url: String, completion: @escaping (Result<UIImage, NSError>) -> Void) {
        network.get(url, parameters: nil) { result in
            switch result {
            case .success(let response):
                if let image = UIImage(data: response.data) {
                    completion(.success(image))
                } else {
                    completion(.failure(Self.error))
                }
            case .failure(let response):
                completion(.failure(response.error))
            }
        }
    }
}
