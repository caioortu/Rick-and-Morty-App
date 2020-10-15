//
//  MainViewModel.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import Foundation

protocol MainViewModelProtocol: class {
    func didGetCharacters()
    func willShowAlert(title: String?, message: String?)
}

protocol MainViewModelType {
    var delegate: MainViewModelProtocol? { get set }
    var characters: [Character]? { get }
    func getCharacters()
}

class MainViewModel: MainViewModelType {
    
    weak var delegate: MainViewModelProtocol?
    private let network = Network(baseURL: "https://rickandmortyapi.com/api")
    
    private(set) var characters: [Character]?
    
    func getCharacters() {
        network.get("/character/") { [weak self] result in
            switch result {
            case .success(let response):
                if let characters = try? JSONDecoder().decode(Character.Response.self, from: response.data) {
                    self?.characters = characters.results
                    self?.delegate?.didGetCharacters()
                } else {
                    self?.delegate?.willShowAlert(title: "Oops!!", message: "Could not get the characters")
                }
            case .failure(let response):
                self?.delegate?.willShowAlert(title: "Oops!!", message: response.error.localizedDescription)
            }
        }
    }
}
