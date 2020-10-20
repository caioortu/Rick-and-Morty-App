//
//  DetailsNetworkControllerTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/20/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_unwrapping
class DetailsNetworkControllerTests: XCTestCase {
    
    var detailsNetworkController: DetailsNetworkControllerType!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        expectation = expectation(description: "Expectation")
    }

    func testGetCharactersSuccessfully() {
        // Given
        let network = CharacterReponseNetworkStub(stubType: .success)
        detailsNetworkController = DetailsNetworkController(network: network)
        
        // When
        detailsNetworkController.getCharacter(id: 1) { result in
            switch result {
            case .success(let character):
                // Then
                XCTAssertEqual(character.id, 1)
                XCTAssertEqual(character.name, "Rick Sanchez")
                XCTAssertEqual(character.status, "Alive")
                XCTAssertEqual(character.species, "Human")
                XCTAssertEqual(character.gender, .male)
            case .failure(let error):
                XCTFail("Something went wrong, \(error.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetCharactersFailed() {
        // Given
        let network = CharacterReponseNetworkStub(stubType: .failure)
        detailsNetworkController = DetailsNetworkController(network: network)
        
        // When
        detailsNetworkController.getCharacter(id: 1) { result in
            switch result {
            case .success:
                XCTFail("Success response was not expected.")
            case .failure(let error):
                // Then
                XCTAssertEqual(error, CharacterReponseNetworkStub.error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

class CharacterReponseNetworkStub: NetworkHandler {
    
    enum StubType {
        case success
        case failure
    }
    
    static var error = NSError(domain: "CharacterReponseNetworkStub doDetails",
                               code: -2,
                               userInfo: ["Description": "CharacterReponseNetworkStub error description"])
    
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
            let path = testBundle.path(forResource: "Character", ofType: "json")
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe) {
                completion(.success(SuccessResponse(data: data, urlResponse: nil)))
            }
        case .failure:
            completion(.failure(FailureResponse(error: Self.error, urlResponse: nil)))
        }
    }
}
