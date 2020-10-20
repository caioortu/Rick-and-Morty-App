//
//  DetailsViewModelTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/20/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
class DetailsViewModelTests: XCTestCase {
    
    private var viewModel: DetailsViewModelType!
    private var delegateCallNames: [DelegateNames] = []
    private var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        let networkController = DetailsNetworkController(network: CharacterReponseNetworkStub(stubType: .success))
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        let favorites = FavoriteCharacters(defaults: userDefaults)
        
        viewModel = DetailsViewModel(id: 0, networkController: networkController, favorites: favorites)
        viewModel.delegate = self
    }
    
    private func failureSetUp() {
        let networkController = DetailsNetworkController(network: CharacterReponseNetworkStub(stubType: .failure))
        viewModel = DetailsViewModel(id: 0, networkController: networkController, favorites: FavoriteCharacters.shared)
        viewModel.delegate = self
    }
    
    private func markFavoritesSetUp() {
        let networkController = DetailsNetworkController(network: CharacterReponseNetworkStub(stubType: .success))
        viewModel = DetailsViewModel(id: 0, networkController: networkController, favorites: FavoriteCharacters.shared)
        viewModel.delegate = self
    }

    // MARK: Tests
    func testInit() {
        // Given
        let viewModel: DetailsViewModelType
        let networkController = DetailsNetworkController(network: CharacterReponseNetworkStub(stubType: .success))
        
        // When
        viewModel = DetailsViewModel(id: 0, networkController: networkController, favorites: FavoriteCharacters.shared)
        
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
    
    func testMarkAsFavorite() {
        // Given
        markFavoritesSetUp()
        let delegateCalled: [DelegateNames] = [.didMarkAsFavorite(true)]
        
        // When
        viewModel.markAsFavorite()
        guard !delegateCallNames.isEmpty else {
            XCTFail("wrong delegate call name for markAsFavorite() call")
            return
        }
        
        // Then
        XCTAssertEqual(delegateCallNames, delegateCalled)
        
        // When
        delegateCallNames = []
        viewModel.markAsFavorite()
        guard !delegateCallNames.isEmpty else {
            XCTFail("wrong delegate call name for markAsFavorite() call")
            return
        }
        
        // Then
        XCTAssertEqual(delegateCallNames, [.didMarkAsFavorite(false)])
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
    
    func testFetchCharacterSuccess() {
        // Given
        let character = Character(id: 1, name: "Rick Sanchez")
        let delegateCalled: [DelegateNames] = [
            .viewShouldLoadFetch(true),
            .viewShouldLoadFetch(false),
            .didCompleteFetch(character.name, id: character.id),
            .didMarkAsFavorite(false)
        ]
        
        // When
        viewModel.fetchCharacter()
        guard !delegateCallNames.isEmpty else {
            XCTFail("wrong delegate call name for fetchCharacter() call")
            return
        }
        
        // Then
        XCTAssertEqual(delegateCallNames, delegateCalled)
    }
    
    func testFetchCharacterFailure() {
        // Given
        failureSetUp()
        let delegateCalled: [DelegateNames] = [
            .viewShouldLoadFetch(true),
            .viewShouldLoadFetch(false),
            .willShowAlert(title: "Oops!!", message: CharacterReponseNetworkStub.error.localizedDescription)
        ]
        
        // When
        viewModel.fetchCharacter()
        guard !delegateCallNames.isEmpty else {
            XCTFail("wrong delegate call name for fetchCharacter() call")
            return
        }
        
        // Then
        XCTAssertEqual(delegateCallNames, delegateCalled)
    }
}

// MARK: DetailsViewModelProtocol
extension DetailsViewModelTests: DetailsViewModelProtocol {
    func didCompleteFetch(with character: Character) {
        delegateCallNames.append(.didCompleteFetch(character.name, id: character.id))
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
    
    func didMarkAsFavorite(_ favorite: Bool) {
        delegateCallNames.append(.didMarkAsFavorite(favorite))
    }
}

// MARK: DelegateNames
private extension DetailsViewModelTests {
    enum DelegateNames: Equatable {
        case didCompleteFetch(_ name: String, id: Int)
        case willShowAlert(title: String?, message: String?)
        case viewShouldLoadFetch(_ loading: Bool)
        case popView
        case didMarkAsFavorite(_ favorite: Bool)
    }
}
