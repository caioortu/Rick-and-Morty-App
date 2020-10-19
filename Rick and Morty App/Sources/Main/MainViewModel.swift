//
//  MainViewModel.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import Foundation

// MARK: MainViewModelProtocol
protocol MainViewModelProtocol: AnyObject {
    func didCompleteFetch(with newIndexPathsToReload: [IndexPath]?)
    func willShowAlert(title: String?, message: String?)
    func viewShouldLoadFetch(_ loading: Bool)
}

// MARK: MainViewModelType
protocol MainViewModelType {
    var delegate: MainViewModelProtocol? { get set }
    var characters: [Character] { get }
    var title: String { get }
    var totalCount: Int { get }
    
    func fetchCharacters()
    func isLoadingCell(for indexPath: IndexPath) -> Bool
}

class MainViewModel: MainViewModelType {
    
    // MARK: Public attributes
    weak var delegate: MainViewModelProtocol?
    let title = ""
    
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
    
    // MARK: Computed properties
    var totalCount: Int {
        return total
    }
    
    // MARK: Public functions
    func fetchCharacters() {
        guard !isFetchInProgress, !hasReachedLastPage else { return }
        
        isFetchInProgress = true
        if characters.isEmpty {
            delegate?.viewShouldLoadFetch(isFetchInProgress)
        }
        
        networkController.getCharacters(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetchInProgress = false
            self.delegate?.viewShouldLoadFetch(self.isFetchInProgress)
            
            switch result {
            case .success(let response):
                self.currentPage += 1
                
                self.total = response.info.count
                self.characters.append(contentsOf: response.results)
                if response.info.prev != nil {
                    self.hasReachedLastPage = response.info.next == nil
                    
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: response.results)
                    self.delegate?.didCompleteFetch(with: indexPathsToReload)
                } else {
                    self.delegate?.didCompleteFetch(with: .none)
                }
            case .failure(let error):
                self.delegate?.willShowAlert(title: "Oops!!", message: error.localizedDescription)
            }
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= characters.count
    }
    
    // MARK: Private functions
    private func calculateIndexPathsToReload(from newCharacters: [Character]) -> [IndexPath] {
        let startIndex = characters.count - newCharacters.count
        let endIndex = startIndex + newCharacters.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
