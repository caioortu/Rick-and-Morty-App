//
//  DetailsNetworkController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/19/20.
//

import Foundation

protocol DetailsNetworkControllerType {
    var network: NetworkHandler { get }
    
    func getCharacter(id: Int, completion: @escaping (Result<Character, NSError>) -> Void)
}

struct DetailsNetworkController: DetailsNetworkControllerType {
    var network: NetworkHandler
    
    func getCharacter(id: Int, completion: @escaping (Result<Character, NSError>) -> Void) {
        
        network.get("/character/\(id)", parameters: nil) { result in
            switch result {
            case .success(let response):
                do {
                    let character = try JSONDecoder().decode(Character.self, from: response.data)
                    completion(.success(character))
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
