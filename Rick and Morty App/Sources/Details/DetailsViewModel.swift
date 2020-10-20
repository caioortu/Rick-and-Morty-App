//
//  DetailsViewModel.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/19/20.
//

import Foundation

// MARK: DetailsViewModelProtocol
protocol DetailsViewModelProtocol: AnyObject {
    func didCompleteFetch(with character: Character)
    func willShowAlert(title: String?, message: String?)
    func viewShouldLoadFetch(_ loading: Bool)
    func popView()
    func didMarkAsFavorite(_ favorite: Bool)
}

// MARK: DetailsViewModelType
protocol DetailsViewModelType {
    var delegate: DetailsViewModelProtocol? { get set }
    
    func fetchCharacter()
    func markAsFavorite()
}

class DetailsViewModel: DetailsViewModelType {
    
    // MARK: Public attributes
    weak var delegate: DetailsViewModelProtocol?
    
    // MARK: Private attributes
    private let networkController: DetailsNetworkControllerType
    private let id: Int
    
    // MARK: Init
    init(id: Int, networkController: DetailsNetworkControllerType) {
        self.networkController = networkController
        self.id = id
    }
    
    // MARK: Public functions
    func fetchCharacter() {
        
        delegate?.viewShouldLoadFetch(true)
        networkController.getCharacter(id: id) { [weak self] result in
            self?.delegate?.viewShouldLoadFetch(false)
            
            switch result {
            case .success(let character):
                self?.delegate?.didCompleteFetch(with: character)
                self?.checkIdForFavorite()
            case .failure(let error):
                self?.delegate?.willShowAlert(title: "Oops!!", message: error.localizedDescription)
                self?.delegate?.popView()
            }
        }
    }
    
    func markAsFavorite() {
        let favorites = FavoriteCharacters.shared
        
        if !isIdMarkedAsFavorite() {
            favorites.addCharacterId(id)
            delegate?.didMarkAsFavorite(true)
        } else {
            favorites.removeCharacterId(id)
            delegate?.didMarkAsFavorite(false)
        }
    }
    
    // MARK: Private functions
    private func isIdMarkedAsFavorite() -> Bool {
        let favorites = FavoriteCharacters.shared
        
        return favorites.getFavoriteCharactersId()?.contains(id) ?? false
    }
    
    private func checkIdForFavorite() {
        delegate?.didMarkAsFavorite(isIdMarkedAsFavorite())
    }
}