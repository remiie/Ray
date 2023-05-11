//
//  APIManager.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit
import Foundation

class APIManager {
    private var imageCache: [URL: UIImage] = [:]
    private let imageURL = "https://loremflickr.com/500/500/"
    
    func fetchImage(withQuery query: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        guard let url = URL(string: imageURL + query) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        if let cachedImage = imageCache[url] {
            completion(.success(cachedImage))
            return
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    self.imageCache[url] = image
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(APIError.invalidImageData))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

enum APIError: Error {
    case invalidImageData
    case invalidURL
    case unknown
}
