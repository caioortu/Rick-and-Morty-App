//
//  Character.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/15/20.
//

import Foundation

struct Character: Codable {
    
    // MARK: Schema
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: Loacation
extension Character {
    struct Location: Codable {
        
        // MARK: Schema
        let name: String
        let url: String
    }
}

// MARK: Gender
extension Character {
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown
    }
}
