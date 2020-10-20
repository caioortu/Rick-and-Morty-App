//
//  FavoritesNetworkController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import Foundation

protocol FavoritesNetworkControllerType {
    var network: NetworkHandler { get }
    
    func getCharacters(ids: [Int], completion: @escaping (Result<[Character], NSError>) -> Void)
}

struct FavoritesNetworkController: FavoritesNetworkControllerType {
    
    let network: NetworkHandler
    
    func getCharacters(ids: [Int], completion: @escaping (Result<[Character], NSError>) -> Void) {
        
        network.get("/character/\(ids)", parameters: nil) { result in
            switch result {
            case .success(let response):
                do {
                    let characters = try JSONDecoder().decode([Character].self, from: response.data)
                    completion(.success(characters))
                } catch {
                    completion(.failure(error as NSError))
                    debugPrint(error.localizedDescription)
                }
            case .failure(let response):
                completion(.failure(response.error))
            }
        }
    }
}
