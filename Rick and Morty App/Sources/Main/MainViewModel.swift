//
//  MainViewModel.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import Foundation

//MARK: MainViewModelProtocol
protocol MainViewModelProtocol: class {
    func didCompleteFetch(with newIndexPathsToReload: [IndexPath]?)
    func willShowAlert(title: String?, message: String?)
}

//MARK: MainViewModelType
protocol MainViewModelType {
    var delegate: MainViewModelProtocol? { get set }
    var characters: [Character] { get }
    var totalCount: Int { get }
    func fetchCharacters()
}

class MainViewModel: MainViewModelType {
    
    // MARK: Public attributes
    weak var delegate: MainViewModelProtocol?
    
    // MARK: Private attributes
    private(set) var characters: [Character] = []
    private var networkController: MainNetworkControllerType
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    private var hasReachedLastPage = false
    
    // MARK: Init
    init(networkController: MainNetworkControllerType) {
        self.networkController = networkController
    }
    
    var totalCount: Int {
        return total
    }
    
    // MARK: Public functions
    func fetchCharacters() {
        guard !isFetchInProgress, !hasReachedLastPage else { return}
        
        isFetchInProgress = true
        networkController.getCharacters(page: currentPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.currentPage += 1
                self?.isFetchInProgress = false
                
                self?.total = response.info.count
                self?.characters.append(contentsOf: response.results)
                if response.info.prev != nil {
                    self?.hasReachedLastPage = response.info.next == nil
                    
                    let indexPathsToReload = self?.calculateIndexPathsToReload(from: response.results)
                    self?.delegate?.didCompleteFetch(with: indexPathsToReload)
                } else {
                    self?.delegate?.didCompleteFetch(with: .none)
                }
            case .failure(let error):
                self?.isFetchInProgress = false
                self?.delegate?.willShowAlert(title: "Oops!!", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: Private functions
    private func calculateIndexPathsToReload(from newCharacters: [Character]) -> [IndexPath] {
        let startIndex = characters.count - newCharacters.count
        let endIndex = startIndex + newCharacters.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
