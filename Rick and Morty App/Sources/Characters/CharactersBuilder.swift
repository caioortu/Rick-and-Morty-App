//
//  CharactersBuilder.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import Foundation

class CharactersBuilder {
    class func build(network: NetworkHandler) -> CharactersViewController {
        let networkController = CharactersNetworkController(network: network)
        let charactersViewModel = CharactersViewModel(networkController: networkController)
        
        return CharactersViewController(viewModel: charactersViewModel, imageDowloader: ImageDownloader())
    }
}
