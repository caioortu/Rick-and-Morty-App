//
//  FavoritesBuilder.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import UIKit

class FavoritesBuilder {
    class func build(network: NetworkHandler) -> FavoritesViewController {
        let networkController = FavoritesNetworkController(network: network)
        let favoritesViewModel = FavoritesViewModel(networkController: networkController)
        
        return FavoritesViewController(viewModel: favoritesViewModel, imageDowloader: ImageDownloader())
    }
}
