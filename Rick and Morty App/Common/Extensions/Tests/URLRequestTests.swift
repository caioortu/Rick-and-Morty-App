//
//  URLRequestTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable force_unwrapping
class URLRequestTests: XCTestCase {

    func testEncode() {
        // Given
        let request = URLRequest(url: URL(string: "www.example.com")!)
        let parameters = ["name": "Rick", "role": "scientist"]
        let urlWithParameters = URL(string: "www.example.com?role=scientist&name=Rick")!
        
        // When
        let encodedRequest = request.encode(with: parameters)
        
        // Then
        XCTAssertNotEqual(encodedRequest, request)
        XCTAssertEqual(encodedRequest.url, urlWithParameters)
    }

}
