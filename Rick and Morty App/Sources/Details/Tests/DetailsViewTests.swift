//
//  DetailsViewTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/20/20.
//

import XCTest
import SnapshotTesting
@testable import Rick_and_Morty_App

class DetailsViewTests: XCTestCase {

    func testDetailsView() {
        // Given
        let detailsView = DetailsView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
        let controller = Controller(detailsView: detailsView)
        let character = Character(name: "Rick Sanchez",
                                  status: "Alive",
                                  species: "Human",
                                  origin: Character.Location(name: "Earth",
                                                             url: ""),
                                  location: Character.Location(name: "Earth 2",
                                                               url: ""))
        let imageDowloader = ImageDownloaderStub()
        
        // When
        detailsView.loadLayout(with: character, imageDownloader: imageDowloader)
        
        // Then
        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
}

private extension DetailsViewTests {
    class Controller: UIViewController {
        
        let detailsView: DetailsView
        
        init(detailsView: DetailsView) {
            self.detailsView = detailsView
            super.init(nibName: nil, bundle: nil)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            view = detailsView
        }
    }
}
