//
//  SceneDelegate.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        AppearanceConfigurator.configure()
        
        guard !isUnitTesting() else { return }
        
        let network = Network(baseURL: "https://rickandmortyapi.com/api")
        let networkController = MainNetworkController(network: network)
        let mainViewModel = MainViewModel(networkController: networkController)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = CustomNavigationController(rootViewController: mainViewController)
        self.window = window
        window.makeKeyAndVisible()
    }

    //MARK: - Private
    private func isUnitTesting() -> Bool {
        // Short-circuit starting app if running unit tests
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        
        return isUnitTesting
    }
}

