//
//  URLRequest+Extension.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/17/20.
//

import Foundation

extension URLRequest {
    func encode(with parameters: [String: String]?) -> URLRequest {
        guard let parameters = parameters else {
            return self
        }
        
        var encodedURLRequest = self
        
        if let url = self.url,
           let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            
            var newUrlComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            newUrlComponents.queryItems = queryItems.sorted { $0.name > $1.name }
            
            encodedURLRequest.url = newUrlComponents.url
            return encodedURLRequest
            
        } else {
            return self
        }
    }
}
