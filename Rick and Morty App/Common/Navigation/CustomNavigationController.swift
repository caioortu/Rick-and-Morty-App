//
//  CustomNavigationController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
