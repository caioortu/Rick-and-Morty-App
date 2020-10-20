//
//  CustomNavigationControllerTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
import SnapshotTesting
@testable import Rick_and_Morty_App

class CustomNavigationControllerTests: XCTestCase {

    // MARK: Tests
    func testCustomNavigationController() {
        // Given
        let controller = Controller()
        
        // When
        let navigationController = CustomNavigationController(rootViewController: controller)
        
        // Then
        assertSnapshot(matching: navigationController, as: .image(on: .iPhoneX))
    }
}

// MARK: Controller
private extension CustomNavigationControllerTests {
    class Controller: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = "The Rick and Morty Test"
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    }
}
