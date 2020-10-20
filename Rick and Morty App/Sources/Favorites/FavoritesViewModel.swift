//
//  FavoritesViewModel.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import Foundation

// MARK: FavoritesViewModelProtocol
protocol FavoritesViewModelProtocol: AnyObject {
    func didCompleteFetch()
    func willShowAlert(title: String?, message: String?)
    func viewShouldLoadFetch(_ loading: Bool)
    func popView()
}

// MARK: FavoritesViewModelType
protocol FavoritesViewModelType {
    var delegate: FavoritesViewModelProtocol? { get set }
    var characters: [Character] { get }
    var networkController: FavoritesNetworkControllerType { get }
    var title: String { get }
    
    func fetchCharacters()
    func popView()
}

class FavoritesViewModel: FavoritesViewModelType {
    
    // MARK: Public attributes
    weak var delegate: FavoritesViewModelProtocol?
    let title = "Your Favorites"
    
    // MARK: Private attributes
    private(set) var characters: [Character] = []
    private(set) var networkController: FavoritesNetworkControllerType
    private var ids: [Int]? { FavoriteCharacters.shared.getFavoriteCharactersId() }
    
    // MARK: Init
    init(networkController: FavoritesNetworkControllerType) {
        self.networkController = networkController
    }
    
    // MARK: Public functions
    func fetchCharacters() {
        
        guard let ids = ids, !ids.isEmpty else {
            delegate?.willShowAlert(title: "Oops!!", message: "You have no favorites yet!")
            return
        }
            
        delegate?.viewShouldLoadFetch(true)
        
        networkController.getCharacters(ids: ids) { [weak self] result in
            self?.delegate?.viewShouldLoadFetch(false)
            
            switch result {
            case .success(let response):
                self?.characters = response
                self?.delegate?.didCompleteFetch()
            case .failure(let error):
                self?.delegate?.willShowAlert(title: "Oops!!", message: error.localizedDescription)
            }
        }
    }
    
    func popView() {
        delegate?.popView()
    }
}
