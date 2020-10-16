//
//  Location.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import Foundation

struct Location: Codable {
    
    // MARK: Schema
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
}
