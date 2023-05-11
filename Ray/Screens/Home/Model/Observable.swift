//
//  Observable.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import Foundation

class Observable<T> {
    typealias Observer = (T) -> Void
    
    private var observer: Observer?
    
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
