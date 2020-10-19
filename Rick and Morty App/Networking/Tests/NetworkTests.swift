//
//  NetworkTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_unwrapping
class NetworkTests: XCTestCase {
    var network: Network!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        network = Network(baseURL: "www.example.com", session: urlSession)
        expectation = expectation(description: "Expectation")
    }
    
    func testGetSuccessfulResponse() {
        // Given
        let urlPath = "/success"
        let data = Data()
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw FailureResponse.mockError
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        network.get(urlPath) { result in
            switch result {
            case .success(let response):
                // Then
                XCTAssertEqual(response.data, data)
            case .failure(let response):
                XCTFail("Error was not expected: \(response.error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetFailureResponse() {
        // Given
        let urlPath = "/failure"
        
        MockURLProtocol.requestHandler = { request in
            throw FailureResponse.mockError
        }
        
        // When
        network.get(urlPath) { result in
            switch result {
            case .success:
                XCTFail("Success response was not expected.")
            case .failure(let response):
                // Then
                XCTAssertEqual(response.error.domain, FailureResponse.mockError.domain)
                XCTAssertEqual(response.error.code, FailureResponse.mockError.code)
                XCTAssertEqual(response.error.localizedDescription, FailureResponse.mockError.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

extension FailureResponse {
    static var mockError: NSError {
        NSError(domain: "www.network.mock.com",
                code: -1,
                userInfo: ["Description": "Mock response error"])
    }
}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
