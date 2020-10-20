//
//  CharactersViewController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import UIKit

class CharactersViewController: UIViewController, AlertDisplayer {
    
    // MARK: Private attributes
    private let charactersView = CharactersView()
    private var viewModel: CharactersViewModelType
    private let imageDowloader: ImageDownloaderType
    
    // MARK: Init
    init(viewModel: CharactersViewModelType, imageDowloader: ImageDownloaderType) {
        self.viewModel = viewModel
        self.imageDowloader = imageDowloader
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func loadView() {
        view = charactersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
        title = viewModel.title
        addFavoritesButton()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.delegate = self
        viewModel.fetchCharacters()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Private functions
    private func configTableView() {
        charactersView.tableView.dataSource = self
        charactersView.tableView.delegate = self
        charactersView.tableView.prefetchDataSource = self
        
        charactersView.registerCells()
    }
    
    // MARK: Private functions
    private func addFavoritesButton() {
        let favotiteButton = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                             style: .done,
                                             target: self,
                                             action: #selector(goToFavorite))
        
        navigationItem.rightBarButtonItem = favotiteButton
    }
    
    @objc private func goToFavorite() {
        let detailsViewController = FavoritesBuilder.build(network: viewModel.networkController.network)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

// MARK: UITableViewDataSource
extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier,
                                                       for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        cell.set(character: viewModel.characters[safe: indexPath.row], imageDowloader: imageDowloader)
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let characterId = viewModel.characters[safe: indexPath.row]?.id {
            let detailsViewController = DetailsBuilder.build(characterId: characterId,
                                                             network: viewModel.networkController.network,
                                                             imageDownloader: ImageDownloader())
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}

// MARK: UITableViewDataSourcePrefetching
extension CharactersViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoadingCell) {
            viewModel.fetchCharacters()
        }
    }
}

// MARK: CharactersViewModelProtocol
extension CharactersViewController: CharactersViewModelProtocol {
    func didCompleteFetch(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            charactersView.tableView.reloadData()
            return
        }
        
        let indexPathsToReload = charactersView.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        charactersView.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func willShowAlert(title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        displayAlert(with: title, message: message, actions: [okAction])
    }
    
    func viewShouldLoadFetch(_ loading: Bool) {
        loading ? charactersView.activityIndicator.startAnimating() : charactersView.activityIndicator.stopAnimating()
        charactersView.tableView.isHidden = loading
    }
}
