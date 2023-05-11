//
//  FavoritesViewModel.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit
import Foundation

final class FavoritesViewModel {
    let favoriteItems = Observable<[FavoriteItem]>([])
    private let favoritesManager: FavoritesManager
    
    init(favoritesManager: FavoritesManager = FavoritesManager()) {
          self.favoritesManager = favoritesManager
      }
    
    func loadFavoriteItems() {
        let items = favoritesManager.getFavoriteItems()
        favoriteItems.value = items
    }

    
    func removeFavoriteItem(_ item: Int) {
        favoritesManager.remove(at: item)
        loadFavoriteItems()
    }
}
