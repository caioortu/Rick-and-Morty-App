//
//  CollectionTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
@testable import Rick_and_Morty_App

class CollectionTests: XCTestCase {

    // MARK: Tests
    func testSafeSubscribe() {
        // Given
        let sut = [1, 2, 3]
        
        // When
        let elementOutOfRange = sut[safe: 3]
        
        // Then
        XCTAssertNil(elementOutOfRange)
    }

}
