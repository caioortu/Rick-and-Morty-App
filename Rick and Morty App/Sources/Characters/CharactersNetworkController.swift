//
//  CharactersNetworkController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import Foundation

protocol CharactersNetworkControllerType {
    var network: NetworkHandler { get }
    
    func getCharacters(page: Int, completion: @escaping (Result<Response<Character>, NSError>) -> Void)
}

struct CharactersNetworkController: CharactersNetworkControllerType {
    
    let network: NetworkHandler
    
    func getCharacters(page: Int, completion: @escaping (Result<Response<Character>, NSError>) -> Void) {
        
        network.get("/character", parameters: ["page": "\(page)"]) { result in
            switch result {
            case .success(let response):
                do {
                    let characters = try JSONDecoder().decode(Response<Character>.self, from: response.data)
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
