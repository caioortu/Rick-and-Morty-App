//
//  AppearanceConfigurator.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import UIKit

class AppearanceConfigurator {
    class func configure() {
        configureUINavigationBar()
    }
    
    private class func configureUINavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9893319011, green: 0.5897573233, blue: 0, alpha: 1)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9893319011, green: 0.5897573233, blue: 0, alpha: 1)]
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
