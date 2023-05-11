//
//  String.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import Foundation

extension String {
   static func replaceSpacesWithCommas(_ input: String) -> String {
        let trimmedString = input.trimmingCharacters(in: .whitespaces)
        let components = trimmedString.components(separatedBy: " ")
        let replacedString = components.joined(separator: ",")
        return replacedString
    }
}
