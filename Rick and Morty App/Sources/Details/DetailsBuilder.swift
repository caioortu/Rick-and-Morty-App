//
//  DetailsBuilder.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import UIKit

class DetailsBuilder {
    class func build(characterId: Int, network: NetworkHandler, imageDownloader: ImageDownloaderType) -> DetailsViewController {
        let networkController = DetailsNetworkController(network: network)
        let viewModel = DetailsViewModel(id: characterId, networkController: networkController)
        
        return DetailsViewController(viewModel: viewModel, imageDowloader: imageDownloader)
    }
}
