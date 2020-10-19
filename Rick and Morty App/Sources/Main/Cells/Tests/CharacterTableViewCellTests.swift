//
//  CharacterTableViewCellTests.swift
//  Rick and Morty AppTests
//
//  Created by Caio Ortu on 10/19/20.
//

import XCTest
import SnapshotTesting
@testable import Rick_and_Morty_App

class CharacterTableViewCellTests: XCTestCase {
    
    let characterCell = CharacterTableViewCell(style: .default, reuseIdentifier: "test")
    let loadingCharacterCell = CharacterTableViewCell(style: .default, reuseIdentifier: "testLoading")

    func testCharacterCell() {
        // Given
        let controller = Controller(cells: [characterCell, loadingCharacterCell])
        let rick = Character(id: 1, name: "Rick Sanchez", location: Character.Location(name: "Earth", url: ""))
        let network = ImageNetworkStub()
        
        // When
        characterCell.set(character: rick, network: network)
        loadingCharacterCell.set(character: .none)
        
        // Then
        XCTAssertNotEqual(characterCell, loadingCharacterCell)
        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
}

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

class ImageNetworkStub: NetworkHandler {
    var baseURL: String = ""
    
    var session: URLSession = .shared
    
    func get(
        _ path: String,
        parameters: [String: String]?,
        completion: @escaping (Result<SuccessResponse, FailureResponse>) -> Void
    ) {
        let image = UIImage(named: "Rick", in: Bundle(for: type(of: self)), compatibleWith: nil)
        if let imageData = image?.pngData() {
            completion(.success(SuccessResponse(data: imageData, urlResponse: nil)))
        }
    }
}
