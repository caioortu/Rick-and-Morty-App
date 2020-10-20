//
//  MainBuilder.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import Foundation

class MainBuilder {
    class func build(network: NetworkHandler) -> MainViewController {
        let networkController = MainNetworkController(network: network)
        let mainViewModel = MainViewModel(networkController: networkController)
        
        return MainViewController(viewModel: mainViewModel, imageDowloader: ImageDownloader())
    }
}
