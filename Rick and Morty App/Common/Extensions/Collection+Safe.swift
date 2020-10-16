//
//  Collection+Safe.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import Foundation

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
