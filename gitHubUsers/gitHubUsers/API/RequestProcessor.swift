//
//  RequestProcessor.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import UIKit

typealias ResponseHeaders = [AnyHashable: Any]

protocol IRequestProcessor: AnyObject {

    func execute<Model>(
        request: IRequest,
        parser: AnyParser<Model>,
        completion: @escaping (Result<(Model, ResponseHeaders), Swift.Error>) -> Void
    ) -> Cancellable?
}

struct Error: LocalizedError {
    /// A readable message that typically should be shown to a user.
    let message: String

    var errorDescription: String? {
        return message
    }
}

enum ApiErrors {
    static let failedCreateUrl = Error(message: "Failed to create url")
    static let failedToParse = Error(message: "Failed to parse response data")
}

/// A simple error type for the API.


final class RequestProcessor: IRequestProcessor {
    
    // Dependencies
    private let session: URLSession
    private let urlRequestBuilder: IURLRequestBuilder
    private let baseJsonParser: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private let errorsByStatusCode: [Int: Error] = [
        422: Error(message: "Validation Failed"),
        503: Error(message: "Service Unavailable"),
    ]
    // MARK: - Init
    
    init(
        session: URLSession = URLSession.shared,
        urlRequestBuilder: IURLRequestBuilder
    ) {
        self.session = session
        self.urlRequestBuilder = urlRequestBuilder
    }
    
    // MARK: - IRequestProcessor
    
    func execute<Model>(
        request: IRequest,
        parser: AnyParser<Model>,
        completion: @escaping (Result<(Model, ResponseHeaders), Swift.Error>) -> Void
    ) -> Cancellable? {
        guard let request = urlRequestBuilder.obtainUrlRequest(from: request) else {
            completion(.failure(Error(message: "Failed to create url")))
            return nil
        }
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                if (error as NSError).code == NSURLErrorCancelled {
                    return
                }
                completion(.failure(error))
                return
            }
            var headers: [AnyHashable: Any] = [:]
    
            if let response = response as? HTTPURLResponse {
                if response.statusCode >= 400 {
                    if let error = self.errorsByStatusCode[response.statusCode] {
                        completion(.failure(error))
                    } else {
                        completion(.failure(Error(message: "Service Unknown Failure")))
                    }
                    return
                }
                headers = response.allHeaderFields
            }
            
            if let data = data, !data.isEmpty {
                do {
                    let result = try parser.parse(data)
                    completion(.success((result, headers)))
                } catch {
                    completion(.failure(ApiErrors.failedToParse))
                }
            } else {
                completion(.failure(ApiErrors.failedToParse))
            }
        }
        task.resume()
        return task
    }
}
