//
//  NetworkController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import Foundation

protocol NetworkHandler {
    var baseURL: String { get }
    var session: URLSession { get }
    
    func get(
        _ path: String,
        parameters: [String: String]?,
        completion: @escaping (_ result: Result<SuccessResponse, FailureResponse>) -> Void
    )
}

struct SuccessResponse {
    let data: Data
    let urlResponse: URLResponse?
}

struct FailureResponse: Error {
    let error: NSError
    let urlResponse: URLResponse?
}

struct Network: NetworkHandler {
    
    // MARK: Private Set Attributes
    private(set) var baseURL: String = ""
    private(set) var session = URLSession.shared
    
    // MARK: Public Attributes
    var headerFields: [String: String]?
    
    // MARK: Public Functions
    
    /// GET request to the specified path.
    ///
    /// - Parameters:
    ///   - path: The path for the GET request.
    ///   - parameters: The parameters to be used in the request.
    ///   - completion: The result of the operation, either a `SuccessResponse` or `FailureResponse`.
    func get(
        _ path: String,
        parameters: [String: String]? = nil,
        completion: @escaping (_ result: Result<SuccessResponse, FailureResponse>) -> Void
    ) {
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
        
        request = request.encode(with: parameters)
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    completion(.success(SuccessResponse(data: data, urlResponse: response)))
                } else if let error = error {
                    completion(.failure(FailureResponse(error: error as NSError, urlResponse: response)))
                }
            }
        }.resume()
    }
}
