//
//  CharacterTableViewCellTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
import SnapshotTesting
@testable import Rick_and_Morty_App

// swiftlint:disable force_unwrapping
class CharacterTableViewCellTests: XCTestCase {
    
    let characterCell = CharacterTableViewCell(style: .default, reuseIdentifier: "test")
    let loadingCharacterCell = CharacterTableViewCell(style: .default, reuseIdentifier: "testLoading")

    // MARK: Tests
    func testCharacterCell() {
        // Given
        let controller = Controller(cells: [characterCell, loadingCharacterCell])
        let rick = Character(id: 1, name: "Rick Sanchez", location: Character.Location(name: "Earth", url: ""))
        let imageDownloader = ImageDownloaderStub()
        
        // When
        characterCell.set(character: rick, imageDowloader: imageDownloader)
        loadingCharacterCell.set(character: .none, imageDowloader: imageDownloader)
        
        // Then
        XCTAssertNotEqual(characterCell, loadingCharacterCell)
        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
}

// MARK: Controller
private extension CharacterTableViewCellTests {
    class Controller: UITableViewController {
        
        let cells: [UITableViewCell]
        
        init(cells: [UITableViewCell]) {
            self.cells = cells
            super.init(nibName: nil, bundle: nil)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            cells.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            cells[indexPath.row]
        }
    }
}

// MARK: ImageDownloaderStub
class ImageDownloaderStub: ImageDownloaderType {
    var network: NetworkHandler = ImageNetworkStub(stubType: .success)
    
    func loadImage(url: String, completion: @escaping (Result<UIImage, NSError>) -> Void) {
        network.get(url, parameters: nil) { result in
            if case let .success(response) = result {
                completion(.success(UIImage(data: response.data)!))
            }
        }
    }
}
