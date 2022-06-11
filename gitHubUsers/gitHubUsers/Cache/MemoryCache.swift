//
//  MemoryCache.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 10.05.2022.
//

import Foundation

protocol ValueSizeDeterminable {
    var count: Int { get }
}

final class MemoryCache<Value: ValueSizeDeterminable>: Cache {
    
    // Properties
    private let serialQueue = DispatchQueue(label: "memoryCacheSerialQueue.gitHubUsers")
    private var items = [String: Value]()
    private var keys = [String]()
    private var size: Int = .zero
    private let maxSize: Int
    
    // Computed Properties
    /// The total size of the cache in bytes.
    var totalSize: Int {
        return serialQueue.sync { size }
    }
    
    // MARK: - Init

    init(maxSize: Int) {
        self.maxSize = maxSize
    }

    // MARK: - Cache
    
    func save(_ model: Value, key: CacheKeyProvader) {
        serialQueue.async {
            if self.isSizeExeected(for: model.count) {
                repeat {
                    if self.keys.isEmpty {
                        return
                    }
                    
                    let oldKey = self.keys.removeFirst()
                    let oldValue = self.items[oldKey]
                    self.items[oldKey] = nil
                    self.size -= oldValue?.count ?? .zero
                } while self.isSizeExeected(for: model.count)
            }
            self.keys.append(key.key)
            self.size += model.count
            self.items[key.key] = model
        }
    }
    
    func fetch(by key: CacheKeyProvader) -> Value? {
        serialQueue.sync {
            items[key.key]
        }
    }
    
    func removeAll() {
        serialQueue.async {
            self.keys.removeAll()
            self.items.removeAll()
            self.size = .zero
        }
    }
    
    // MARK: - Private
    
    private func isSizeExeected(for valueSize: Int) -> Bool {
        return size + valueSize > maxSize
    }
}
