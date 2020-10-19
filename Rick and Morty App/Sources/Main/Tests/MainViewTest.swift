//
//  MainViewTest.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
import SnapshotTesting
@testable import Rick_and_Morty_App

class MainViewTest: XCTestCase {
    
    func testMainView() {
        // Given
        let mainView = MainView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
        
        // When/Then
        assertSnapshot(matching: mainView, as: .image)
    }
}
