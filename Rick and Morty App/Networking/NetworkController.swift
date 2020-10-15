//
//  NetworkController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import Foundation

struct Network {
    
    struct SuccessResponse {
        let data: Data
        let urlResponse: URLResponse
    }
    
    struct FailureResponse: Error {
        let error: NSError
        let urlResponse: URLResponse
    }
    
    private(set) var baseURL: String = ""
    private(set) var configuration: URLSessionConfiguration = .default
    var headerFields: [String: String]?
    
    func get(_ path: String,
             parameters: [String: Any]? = nil,
             completion: @escaping (_ result: Result<SuccessResponse, FailureResponse>) -> Void) {
        let urlString = baseURL + path
        guard let url = URL(string: urlString) else {
            fatalError("Unable to get the correct URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let headerFields = headerFields {
            for (key, value) in headerFields {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        let session = URLSession(configuration: configuration)
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let response = response {
                    if let data = data, error == nil {
                        completion(.success(SuccessResponse(data: data, urlResponse: response)))
                    } else if let error = error {
                        completion(.failure(FailureResponse(error: error as NSError, urlResponse: response)))
                    }
                }
            }
        }.resume()
    }
}
