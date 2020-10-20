//
//  ImageDownloaderTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/20/20.
//

import XCTest
import SnapshotTesting
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
class ImageDownloaderTests: XCTestCase {
    
    private var imageDownloader: ImageDownloaderType!
    private var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        expectation = expectation(description: "Expectation")
    }
    
    // MARK: Tests
    func testGetCharactersSuccessfully() {
        // Given
        let network = ImageNetworkStub(stubType: .success)
        imageDownloader = ImageDownloader(network: network)
        
        // When
        imageDownloader.loadImage(url: "") { result in
            switch result {
            case .success(let image):
                // Then
                assertSnapshot(matching: image, as: .image)
            case .failure(let error):
                XCTFail("Something went wrong, \(error.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetCharactersFailed() {
        // Given
        let network = ImageNetworkStub(stubType: .failure)
        imageDownloader = ImageDownloader(network: network)
        
        // When
        imageDownloader.loadImage(url: "") { result in
            switch result {
            case .success:
                XCTFail("Success response was not expected.")
            case .failure(let error):
                // Then
                XCTAssertEqual(error, ImageNetworkStub.error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: ImageNetworkStub
class ImageNetworkStub: NetworkHandler {
    enum StubType {
        case success
        case failure
    }
    
    static var error = NSError(domain: "ImageNetworkStub domain",
                               code: -2,
                               userInfo: ["Description": "ImageNetworkStub error description"])
    
    var baseURL: String = ""
    
    var session: URLSession = URLSession.shared
    
    let stubType: StubType
    
    init(stubType: StubType) {
        self.stubType = stubType
    }
    
    func get(
        _ path: String,
        parameters: [String: String]?,
        completion: @escaping (Result<SuccessResponse, FailureResponse>) -> Void
    ) {
        switch stubType {
        case .success:
            let image = UIImage(named: "Rick", in: Bundle(for: type(of: self)), compatibleWith: nil)
            if let imageData = image?.pngData() {
                completion(.success(SuccessResponse(data: imageData, urlResponse: nil)))
            }
        case .failure:
            completion(.failure(FailureResponse(error: Self.error, urlResponse: nil)))
        }
    }
}
