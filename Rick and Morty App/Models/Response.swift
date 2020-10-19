//
//  Response.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import Foundation

struct Response<T: Codable & Equatable>: Codable, Equatable {
    
    // MARK: Info
    struct Info: Codable, Equatable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    // MARK: Schema
    let info: Info
    let results: [T]
}
