//
//  FavoriteItem.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit
import Foundation

struct FavoriteItem: Codable {
    let imageData: Data
    let description: String
    
    var image: UIImage? {
        return UIImage(data: imageData)
    }
    
    init(image: UIImage, description: String) {
        self.imageData = image.jpegData(compressionQuality: 1.0) ?? Data()
        self.description = description
    }
}

