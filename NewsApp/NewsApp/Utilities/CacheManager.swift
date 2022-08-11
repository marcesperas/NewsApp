//
//  CacheManager.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import Foundation

protocol CacheManagerProtocol {
    func save(key: String, data: Data)
    func fetch(key: String) -> Data?
}

class CacheManager: CacheManagerProtocol {
    static let shared: CacheManager = CacheManager()
    private var cache: NSCache<NSString, NSData>

    init() {
        self.cache = NSCache<NSString, NSData>()
        self.cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
    }
    
    func save(key: String, data: Data) {
        cache.setObject(NSData(data: data), forKey: key as NSString)
    }
    
    func fetch(key: String) -> Data? {
        if let cacheObject = cache.object(forKey: key as NSString) {
            let data = Data(referencing: cacheObject)
            return data
        }

        return nil
    }
}
