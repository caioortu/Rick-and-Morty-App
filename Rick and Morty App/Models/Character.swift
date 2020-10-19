//
//  Character.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/15/20.
//

import Foundation

struct Character: Codable, Equatable {
    
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
    
    init(id: Int = 0,
         name: String = "",
         status: String = "",
         species: String = "",
         type: String = "",
         gender: Gender = .unknown,
         origin: Location = Location(name: "", url: ""),
         location: Location = Location(name: "", url: ""),
         image: String = "",
         episode: [String] = [],
         url: String = "",
         created: String = "") {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
}

// MARK: Loacation
extension Character {
    struct Location: Codable, Equatable {
        
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
