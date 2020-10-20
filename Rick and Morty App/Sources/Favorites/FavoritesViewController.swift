//
//  FavoritesViewController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import UIKit

class FavoritesViewController: UIViewController, AlertDisplayer {
    
    // MARK: Private attributes
    private let charactersView = CharactersView()
    private var viewModel: FavoritesViewModelType
    private let imageDowloader: ImageDownloaderType
    
    // MARK: Init
    init(viewModel: FavoritesViewModelType, imageDowloader: ImageDownloaderType) {
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
        navigationItem.largeTitleDisplayMode = .never
        
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchCharacters()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Private functions
    private func configTableView() {
        charactersView.tableView.dataSource = self
        charactersView.tableView.delegate = self
        
        charactersView.registerCells()
    }
}

// MARK: UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.characters.count
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
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let characterId = viewModel.characters[safe: indexPath.row]?.id {
            let detailsViewController = DetailsBuilder.build(characterId: characterId,
                                                             network: viewModel.networkController.network,
                                                             imageDownloader: ImageDownloader())
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}

// MARK: FavoritesViewModelProtocol
extension FavoritesViewController: FavoritesViewModelProtocol {
    func didCompleteFetch() {
        charactersView.tableView.reloadData()
    }
    
    func willShowAlert(title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] _ in
            viewModel.popView()
        }
        
        displayAlert(with: title, message: message, actions: [okAction])
    }
    
    func viewShouldLoadFetch(_ loading: Bool) {
        loading ? charactersView.activityIndicator.startAnimating() : charactersView.activityIndicator.stopAnimating()
        charactersView.tableView.isHidden = loading
    }
    
    func popView() {
        navigationController?.popViewController(animated: true)
    }
}
