//
//  ImageService.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 09.05.2022.
//

import Foundation
import UIKit

protocol ImageProvider: AnyObject {

    func image(from url: URL?, completion: @escaping((UIImage?) -> Void)) -> Cancellable?
}

protocol Cancellable: AnyObject {

    func cancel()
}

final class ImageService: ImageProvider {
    
    // Dependencies
    private let imageCache: AnyCache<Data>
    private let session: URLSession
    
    // MARK: - Init

    init(
        session: URLSession = URLSession.shared,
        imageCache: AnyCache<Data>
    ) {
        self.session = session
        self.imageCache = imageCache
    }
    
    // MARK: - IImageService
    
    func image(from url: URL?, completion: @escaping((UIImage?) -> Void)) -> Cancellable? {
        guard let url = url else {
            completion(nil)
            return nil
        }
        if let cachedImageData = imageCache.fetch(by: url),
           let image = UIImage(data: cachedImageData) {
            completion(image)
            return nil
        } else {
            let task = session.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    if (error as NSError).code == NSURLErrorCancelled {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    self?.imageCache.save(data, key: url)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
            task.resume()
            return task
        }
    }
}

extension URLSessionTask: Cancellable {}

extension URL: CacheKeyProvader {
    
    var key: String {
        absoluteString
    }
}
