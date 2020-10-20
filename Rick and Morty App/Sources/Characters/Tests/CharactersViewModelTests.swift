//
//  CharactersViewModelTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
class CharactersViewModelTests: XCTestCase {
    
    private var viewModel: CharactersViewModelType!
    private var delegateCallNames: [DelegateNames] = []
    
    override func setUp() {
        super.setUp()
        
        let networkController = CharactersNetworkController(network: CharactersReponseNetworkStub(stubType: .success))
        viewModel = CharactersViewModel(networkController: networkController)
        viewModel.delegate = self
    }
    
    private func failureSetUp() {
        let networkController = CharactersNetworkController(network: CharactersReponseNetworkStub(stubType: .failure))
        viewModel = CharactersViewModel(networkController: networkController)
        viewModel.delegate = self
    }

    // MARK: Tests
    func testInit() {
        // Given
        let viewModel: CharactersViewModelType
        let networkController = CharactersNetworkController(network: CharactersReponseNetworkStub(stubType: .success))
        
        // When
        viewModel = CharactersViewModel(networkController: networkController)
        
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
        let title = "The Rick and Morty App"
        
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
    
    func testTotalCount() {
        // Given
        let totalCount = 671
        
        // Then
        XCTAssertEqual(viewModel.totalCount, 0)
        
        // When
        viewModel.fetchCharacters()
        
        // Then
        XCTAssertEqual(viewModel.totalCount, totalCount)
    }
    
    func testIsLoadingCellIndexPath() {
        // Given
        let indexPath: IndexPath = [0, 1]
        var isLoading = viewModel.isLoadingCell(for: indexPath)
        
        // Then
        XCTAssertEqual(isLoading, true)
        
        // When
        viewModel.fetchCharacters()
        isLoading = viewModel.isLoadingCell(for: indexPath)
        
        // Then
        XCTAssertEqual(isLoading, false)
    }
    
    func testFetchCharactersSuccess() {
        // Given
        let delegateCalled: [DelegateNames] = [
            .viewShouldLoadFetch(true),
            .viewShouldLoadFetch(false),
            .didCompleteFetch(.none)
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
            .willShowAlert(title: "Oops!!", message: CharactersReponseNetworkStub.error.localizedDescription)
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
extension CharactersViewModelTests: CharactersViewModelProtocol {
    func didCompleteFetch(with newIndexPathsToReload: [IndexPath]?) {
        delegateCallNames.append(.didCompleteFetch(newIndexPathsToReload))
    }
    
    func willShowAlert(title: String?, message: String?) {
        delegateCallNames.append(.willShowAlert(title: title, message: message))
    }
    
    func viewShouldLoadFetch(_ loading: Bool) {
        delegateCallNames.append(.viewShouldLoadFetch(loading))
    }
}

// MARK: DelegateNames
private extension CharactersViewModelTests {
    enum DelegateNames: Equatable {
        case didCompleteFetch(_ index: [IndexPath]?)
        case willShowAlert(title: String?, message: String?)
        case viewShouldLoadFetch(_ loading: Bool)
    }
}
