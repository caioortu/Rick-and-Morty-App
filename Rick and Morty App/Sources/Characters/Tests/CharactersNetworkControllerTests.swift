//
//  CharactersNetworkControllerTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_unwrapping
class CharactersNetworkControllerTests: XCTestCase {
    
    private var charactersNetworkController: CharactersNetworkControllerType!
    private var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        expectation = expectation(description: "Expectation")
    }

    // MARK: Tests
    func testGetCharactersSuccessfully() {
        // Given
        let network = CharactersReponseNetworkStub(stubType: .success)
        charactersNetworkController = CharactersNetworkController(network: network)
        let info = Response<Character>.Info(count: 671, pages: 34, next: "page=2", prev: nil)
        
        // When
        charactersNetworkController.getCharacters(page: 1) { result in
            switch result {
            case .success(let response):
                // Then
                XCTAssertEqual(response.info, info)
                XCTAssertEqual(response.results.first?.id, 1)
                XCTAssertEqual(response.results.first?.name, "Rick Sanchez")
                XCTAssertEqual(response.results.first?.status, "Alive")
                XCTAssertEqual(response.results.first?.species, "Human")
                XCTAssertEqual(response.results.first?.gender, .male)
            case .failure(let error):
                XCTFail("Something went wrong, \(error.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetCharactersFailed() {
        // Given
        let network = CharactersReponseNetworkStub(stubType: .failure)
        charactersNetworkController = CharactersNetworkController(network: network)
        
        // When
        charactersNetworkController.getCharacters(page: 1) { result in
            switch result {
            case .success:
                XCTFail("Success response was not expected.")
            case .failure(let error):
                // Then
                XCTAssertEqual(error, CharactersReponseNetworkStub.error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: CharactersReponseNetworkStub
class CharactersReponseNetworkStub: NetworkHandler {
    
    enum StubType {
        case success
        case failure
    }
    
    static var error = NSError(domain: "CharactersReponseNetworkStub domain",
                               code: -2,
                               userInfo: ["Description": "CharactersReponseNetworkStub error description"])
    
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
            let path = testBundle.path(forResource: "CharactersResponse", ofType: "json")
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe) {
                completion(.success(SuccessResponse(data: data, urlResponse: nil)))
            }
        case .failure:
            completion(.failure(FailureResponse(error: Self.error, urlResponse: nil)))
        }
    }
}
