//
//  HomeViewModel.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit
import Foundation

class HomeViewModel {
    let image: Observable<UIImage?> = Observable(nil)
    let query: Observable<String?> = Observable(nil)
    let error: Observable<Error?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    
    private let apiManager: APIManager
    private let favoritesManager: FavoritesManager
    
    init(apiManager: APIManager = APIManager(), favoritesManager: FavoritesManager = FavoritesManager()) {
        self.apiManager = apiManager
        self.favoritesManager = favoritesManager
    }
    
    func addToFavorites(image: UIImage) {
        favoritesManager.add(image: image, description: query.value ?? "")
    }
    
    func fetchImage(withQuery query: String) {
        isLoading.value = true
        let correctQuery = String.replaceSpacesWithCommas(query)
      
        
        apiManager.fetchImage(withQuery: correctQuery) { [weak self] result in
            
            self?.isLoading.value = false
            self?.query.value = query
            switch result {
            case .success(let image):
                self?.image.value = image
                
            case .failure(let error):
                self?.error.value = error
            }
        }
    }
    
}
