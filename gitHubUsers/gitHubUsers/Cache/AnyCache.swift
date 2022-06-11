//
//  File.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 10.05.2022.
//

import Foundation

final class AnyCache<Model>: Cache {
    
    // Properteis
    private let _save: (Model, CacheKeyProvader) -> Void
    private let _fetch: (CacheKeyProvader) -> Model?
    private let _removeAll: () -> Void
    
    // MARK: - Init
    
    init<CacheModel: Cache>(cache: CacheModel) where CacheModel.Model == Model {
        _save = cache.save
        _fetch = cache.fetch
        _removeAll = cache.removeAll
    }
    
    // MARK: - Cache
    
    func save(_ model: Model, key: CacheKeyProvader) {
        _save(model, key)
    }
    
    func fetch(by key: CacheKeyProvader) -> Model? {
        _fetch(key)
    }
    
    func removeAll() {
        _removeAll()
    }
}

extension Cache {
    
    func typeErased() -> AnyCache<Model> {
        AnyCache<Model>(cache: self)
    }
}
