//
//  Character.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/15/20.
//

import Foundation

struct Character: Codable {
    
    struct Response: Codable {
        let results: [Character]
    }
    
    let id: Int
    let name: String
//    let status: String
//    let species: String
//    let type: String
//    let gender: String
//    "origin": {
//      "name": "Earth (C-137)",
//      "url": "https://rickandmortyapi.com/api/location/1"
//    },
//    "location": {
//      "name": "Earth (Replacement Dimension)",
//      "url": "https://rickandmortyapi.com/api/location/20"
//    },
//    "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
//    "episode": [
//      "https://rickandmortyapi.com/api/episode/1",
//      "https://rickandmortyapi.com/api/episode/2",
//      // ...
//    ],
//    "url": "https://rickandmortyapi.com/api/character/1",
//    "created": "2017-11-04T18:48:46.250Z"
}
