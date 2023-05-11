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
    let error: Observable<Error?> = Observable(nil)
    
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager()) {
        self.apiManager = apiManager
    }
    
    func fetchImage(withQuery query: String) {
        let imageURL = URL(string: "https://dummyimage.com/500x500&text=some+\(query)")!
        apiManager.fetchImage(withURL: imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image.value = image
            case .failure(let error):
                self?.error.value = error
            }
        }
    }
}
