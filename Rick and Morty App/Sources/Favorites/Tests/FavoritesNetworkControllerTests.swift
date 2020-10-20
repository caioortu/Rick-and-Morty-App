//
//  FavoritesNetworkControllerTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/20/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_unwrapping
class FavoritesNetworkControllerTests: XCTestCase {
    
    private var favoritesNetworkController: FavoritesNetworkControllerType!
    private var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        expectation = expectation(description: "Expectation")
    }

    // MARK: Tests
    func testGetCharactersSuccessfully() {
        // Given
        let network = CharactersNetworkStub(stubType: .success)
        favoritesNetworkController = FavoritesNetworkController(network: network)
        
        // When
        favoritesNetworkController.getCharacters(ids: []) { result in
            switch result {
            case .success(let response):
                // Then
                XCTAssertEqual(response.first?.id, 1)
                XCTAssertEqual(response.first?.name, "Rick Sanchez")
                XCTAssertEqual(response.first?.status, "Alive")
                XCTAssertEqual(response.first?.species, "Human")
                XCTAssertEqual(response.first?.gender, .male)
            case .failure(let error):
                XCTFail("Something went wrong, \(error.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetCharactersFailed() {
        // Given
        let network = CharactersNetworkStub(stubType: .failure)
        favoritesNetworkController = FavoritesNetworkController(network: network)
        
        // When
        favoritesNetworkController.getCharacters(ids: []) { result in
            switch result {
            case .success:
                XCTFail("Success response was not expected.")
            case .failure(let error):
                // Then
                XCTAssertEqual(error, CharactersNetworkStub.error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: CharactersNetworkStub
class CharactersNetworkStub: NetworkHandler {
    
    enum StubType {
        case success
        case failure
    }
    
    static var error = NSError(domain: "CharactersNetworkStub domain",
                               code: -2,
                               userInfo: ["Description": "CharactersNetworkStub error description"])
    
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
            let testBundle = Bundle(for: type(of: self))
            let path = testBundle.path(forResource: "Characters", ofType: "json")
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe) {
                completion(.success(SuccessResponse(data: data, urlResponse: nil)))
            }
        case .failure:
            completion(.failure(FailureResponse(error: Self.error, urlResponse: nil)))
        }
    }
}
