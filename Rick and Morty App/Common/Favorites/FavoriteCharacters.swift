//
//  FavoriteCharacters.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/20/20.
//

import Foundation

struct FavoriteCharacters {
    static let favoritesKey = "FavoriteCharactersId"
    
    static let shared = FavoriteCharacters(defaults: UserDefaults.standard)
    
    let defaults: UserDefaults
    
    func getFavoriteCharactersId() -> [Int]? {
        guard let data = defaults.value(forKey: Self.favoritesKey) as? Data else { return nil }
        return try? JSONDecoder().decode([Int].self, from: data)
    }
    
    func addCharacterId(_ id: Int?) {
        guard let id = id else { return }
        guard var favoritesId = getFavoriteCharactersId() else {
            defaults.set(try? JSONEncoder().encode([id]), forKey: Self.favoritesKey)
            return
        }
        favoritesId = favoritesId.filter { $0 != id }
        favoritesId.append(id)
        
        defaults.set(try? JSONEncoder().encode(favoritesId), forKey: Self.favoritesKey)
    }
    
    func removeCharacterId(_ id: Int?) {
        guard let id = id, var favoritesId = getFavoriteCharactersId() else { return }
        favoritesId.removeAll { $0 == id }
        
        defaults.set(try? JSONEncoder().encode(favoritesId), forKey: Self.favoritesKey)
    }
}
