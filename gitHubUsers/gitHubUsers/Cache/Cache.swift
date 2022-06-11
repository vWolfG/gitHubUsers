//
//  Cache.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 10.05.2022.
//

import Foundation

protocol Cache: AnyObject {
    associatedtype Model
    
    func save(_ model: Model, key: CacheKeyProvader)
    func fetch(by key: CacheKeyProvader) -> Model?
    func removeAll()
}

protocol CacheKeyProvader {
    var key: String { get }
}
