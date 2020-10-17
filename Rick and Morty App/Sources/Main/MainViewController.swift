//
//  MainViewController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import UIKit

class MainViewController: UIViewController, AlertDisplayer {
    
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
        configTableView()
        
        title = "The Rick and Morty App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mainView.activityIndicator.startAnimating()
        mainView.tableView.isHidden = true
        
        viewModel.delegate = self
        viewModel.fetchCharacters()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Private functions
    private func configTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.prefetchDataSource = self
        
        registerCells()
    }
    
    private func registerCells() {
        mainView.tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = mainView.tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.characters.count
    }
}

// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier,
                                                       for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
            cell.set(character: .none)
        } else {
            cell.set(character: viewModel.characters[safe: indexPath.row])
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSourcePrefetching
extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchCharacters()
        }
    }
}

// MARK: MainViewModelProtocol
extension MainViewController: MainViewModelProtocol {
    func didCompleteFetch(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            mainView.activityIndicator.stopAnimating()
            mainView.tableView.isHidden = false
            
            mainView.tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        mainView.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func willShowAlert(title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        displayAlert(with: title, message: message, actions: [okAction])
    }
}
