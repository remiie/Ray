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

    func fetchImage(withURL url: URL, completion: @escaping (Result<UIImage, Error>) -> ()) {
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
}
