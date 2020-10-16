//
//  NetworkController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import Foundation

struct Network {
    
    // MARK: SuccessResponse
    struct SuccessResponse {
        let data: Data
        let urlResponse: URLResponse
    }
    
    // MARK: FailureResponse
    struct FailureResponse: Error {
        let error: NSError
        let urlResponse: URLResponse
    }
    
    // MARK: Private Set Attributes
    private(set) var baseURL: String = ""
    private(set) var configuration: URLSessionConfiguration = .default
    
    // MARK: Public Attributes
    var headerFields: [String: String]?
    
    // MARK: Public Functions
    
    /// GET request to the specified path.
    ///
    /// - Parameters:
    ///   - path: The path for the GET request.
    ///   - parameters: The parameters to be used in the request.
    ///   - completion: The result of the operation, either a `SuccessResponse` or `FailureResponse`.
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
