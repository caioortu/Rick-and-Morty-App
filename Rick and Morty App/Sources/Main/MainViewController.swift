//
//  MainViewController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Private attributes
    private let mainView = MainView()
    private var viewModel: MainViewModelType
    
    // MARK: Init
    init(viewModel: MainViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
        registerCells()
        
        viewModel.delegate = self
        viewModel.getCharacters()
    }
    
    // MARK: Private functions
    private func registerCells() {
        mainView.tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
    }
}

// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.characters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier,
                                                       for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        if let character = viewModel.characters?[safe: indexPath.row] {
            cell.set(character: character)
        }
        
        return cell
    }
}

// MARK: MainViewModelProtocol
extension MainViewController: MainViewModelProtocol {
    func didGetCharacters() {
        mainView.tableView.reloadData()
    }
    
    func willShowAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
