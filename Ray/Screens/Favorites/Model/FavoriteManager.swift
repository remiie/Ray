//
//  FavoriteManager.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit
import SQLite
import Foundation

final class FavoritesManager {
    private let database: Connection
    private let favoritesTable = Table("Favorites")
    private let id = Expression<Int>("id")
    private let image = Expression<Data>("image")
    private let description = Expression<String>("description")
    private let favoriteItems = Observable<[FavoriteItem]>([])
    private let maxFavoriteItems = 10
    
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let database = try Connection("\(path)/favorites.sqlite3")
            self.database = database
            
            createFavoritesTableIfNeeded()
        } catch {
            fatalError("Failed to initialize database: \(error)")
        }
    }
    
    private func createFavoritesTableIfNeeded() {
        do {
            try database.run(favoritesTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(image)
                table.column(description)
            })
        } catch {
            fatalError("Failed to create Favorites table: \(error)")
        }
    }
    
    func add(image: UIImage, description: String) {
        let item = FavoriteItem(image: image, description: description)
        var favoriteItems = getFavoriteItems()

        if favoriteItems.count >= maxFavoriteItems {
            favoriteItems.removeFirst()
        }

        favoriteItems.append(item)
        saveFavoriteItems(favoriteItems)
    }

    func remove(at index: Int) {
        var favoriteItems = getFavoriteItems()

        guard index >= 0 && index < favoriteItems.count else {
            print("Invalid index for item removal")
            return
        }

        favoriteItems.remove(at: index)
        saveFavoriteItems(favoriteItems)
    }
    func getFavoriteItems() -> [FavoriteItem] {
        var favoriteItems: [FavoriteItem] = []
        
        do {
            for row in try database.prepare(favoritesTable) {
                let imageData = row[image]
                let image = UIImage(data: imageData) ?? UIImage()
                let description = row[self.description]
                let item = FavoriteItem(image: image, description: description)
                favoriteItems.append(item)
            }
        } catch {
            print("Failed to fetch favorite items: \(error)")
        }
        
        self.favoriteItems.value = favoriteItems
        return favoriteItems
    }

    
    private func saveFavoriteItems(_ items: [FavoriteItem]) {
        do {
            try database.run(favoritesTable.delete())

            for (_, item) in items.enumerated() {
                let imageData = item.image?.jpegData(compressionQuality: 1.0) ?? Data()
                let insert = favoritesTable.insert(image <- imageData, description <- item.description)
                try database.run(insert)
            }
            
            self.favoriteItems.value = items
        } catch {
            print("Failed to save favorite items: \(error)")
        }
    }

    
}
