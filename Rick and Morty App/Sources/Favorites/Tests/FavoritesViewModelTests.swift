//
//  FavoritesViewModelTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/20/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
class FavoritesViewModelTests: XCTestCase {

    private var viewModel: FavoritesViewModelType!
    private var delegateCallNames: [DelegateNames] = []
    
    override func setUp() {
        super.setUp()
        
        let networkController = FavoritesNetworkController(network: CharactersNetworkStub(stubType: .success))
        viewModel = FavoritesViewModel(networkController: networkController)
        viewModel.delegate = self
    }
    
    private func failureSetUp() {
        let networkController = FavoritesNetworkController(network: CharactersNetworkStub(stubType: .failure))
        viewModel = FavoritesViewModel(networkController: networkController)
        viewModel.delegate = self
    }

    // MARK: Tests
    func testInit() {
        // Given
        let viewModel: FavoritesViewModelType
        let networkController = FavoritesNetworkController(network: CharactersNetworkStub(stubType: .success))
        
        // When
        viewModel = FavoritesViewModel(networkController: networkController)
        
        // Then
        XCTAssertNotNil(viewModel)
    }
    
    func testAddDelegate() {
        // Given
        let delegate = self
        
        // When
        viewModel.delegate = delegate
        
        // Then
        XCTAssertNotNil(viewModel.delegate)
    }
    
    func testTitle() {
        // Given
        let title = "Your Favorites"
        
        // When/Then
        XCTAssertEqual(viewModel.title, title)
    }
    
    func testCharacters() {
        // Given
        let numberOfCharacter = 5
        
        // Then
        XCTAssertTrue(viewModel.characters.isEmpty)
        
        // When
        viewModel.fetchCharacters()
        
        // Then
        XCTAssertEqual(viewModel.characters.count, numberOfCharacter)
    }
    
    func testPopView() {
        // Given
        let delegateCalled: [DelegateNames] = [.popView]
        
        // When
        viewModel.popView()
        guard !delegateCallNames.isEmpty else {
            XCTFail("wrong delegate call name for popView() call")
            return
        }
        
        // Then
        XCTAssertEqual(delegateCallNames, delegateCalled)
    }
    
    func testFetchCharactersSuccess() {
        // Given
        let delegateCalled: [DelegateNames] = [
            .viewShouldLoadFetch(true),
            .viewShouldLoadFetch(false),
            .didCompleteFetch
        ]
        
        // When
        viewModel.fetchCharacters()
        guard !delegateCallNames.isEmpty else {
            XCTFail("wrong delegate call name for fetchCharacters() call")
            return
        }
        
        // Then
        XCTAssertEqual(delegateCallNames, delegateCalled)
    }
    
    func testFetchCharactersFailure() {
        // Given
        failureSetUp()
        let delegateCalled: [DelegateNames] = [
            .viewShouldLoadFetch(true),
            .viewShouldLoadFetch(false),
            .willShowAlert(title: "Oops!!", message: CharactersNetworkStub.error.localizedDescription)
        ]
        
        // When
        viewModel.fetchCharacters()
        guard !delegateCallNames.isEmpty else {
            XCTFail("wrong delegate call name for fetchCharacters() call")
            return
        }
        
        // Then
        XCTAssertEqual(delegateCallNames, delegateCalled)
    }
}

// MARK: CharactersViewModelProtocol
extension FavoritesViewModelTests: FavoritesViewModelProtocol {
    func didCompleteFetch() {
        delegateCallNames.append(.didCompleteFetch)
    }
    
    func willShowAlert(title: String?, message: String?) {
        delegateCallNames.append(.willShowAlert(title: title, message: message))
    }
    
    func viewShouldLoadFetch(_ loading: Bool) {
        delegateCallNames.append(.viewShouldLoadFetch(loading))
    }
    
    func popView() {
        delegateCallNames.append(.popView)
    }
}

// MARK: DelegateNames
private extension FavoritesViewModelTests {
    enum DelegateNames: Equatable {
        case didCompleteFetch
        case willShowAlert(title: String?, message: String?)
        case viewShouldLoadFetch(_ loading: Bool)
        case popView
    }
}
