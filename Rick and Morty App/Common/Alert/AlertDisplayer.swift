//
//  AlertDisplayer.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import UIKit

protocol AlertDisplayer {
    func displayAlert(with title: String?, message: String?, actions: [UIAlertAction]?)
}

extension AlertDisplayer where Self: UIViewController {
    func displayAlert(with title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}
