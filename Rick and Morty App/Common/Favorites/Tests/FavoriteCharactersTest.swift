//
//  FavoriteCharactersTest.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/20/20.
//

import XCTest
@testable import Rick_and_Morty_App

// swiftlint:disable implicitly_unwrapped_optional
class FavoriteCharactersTest: XCTestCase {
    
    private var userDefaults: UserDefaults!
    private var favorite: FavoriteCharacters!
    
    override func setUp() {
        super.setUp()
        
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        
        favorite = FavoriteCharacters(defaults: userDefaults)
    }

    func testFavoriteCharacters() {
        // Given
        let ids = [1, 2, 3, 5]
        let idsWithoutLast = [1, 2, 3]
        
        // Then
        XCTAssertNil(favorite.getFavoriteCharactersId())
        
        // When
        for id in ids {
            favorite.addCharacterId(id)
        }
        
        // Then
        XCTAssertEqual(favorite.getFavoriteCharactersId(), ids)
        
        // When
        favorite.removeCharacterId(5)
        
        // Then
        XCTAssertEqual(favorite.getFavoriteCharactersId(), idsWithoutLast)
    }

}
