//
//  URLRequestBuilder.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import OSLog
import Foundation

protocol IURLRequestBuilder: AnyObject {

    func obtainUrlRequest(from request: IRequest) -> URLRequest?
}

final class URLRequestBuilder: IURLRequestBuilder {
    
    func obtainUrlRequest(from request: IRequest) -> URLRequest? {
        var baseUrl = request.domen()
        if let path = request.extraPath() {
            baseUrl.append(contentsOf: path)
        }
        if !request.parameters().isEmpty {
            let parameters = obtainParameters(from: request.parameters())
            baseUrl += "?" + parameters.map { $0.key + "=" + $0.value.description }.joined(separator: "&")
        }
        guard let url = URL(string: baseUrl) else { return nil}
        // Set queries
        var newRequest = URLRequest(url: url)
        var headers = request.headers()
        if request.needToken() {
            headers["Authorization"] = "token \(Environment.githubToken)"
        }
        newRequest.allHTTPHeaderFields = headers.mapValues { $0.description }
        newRequest.httpBody = request.body()
        newRequest.httpMethod = request.method().rawValue
        newRequest.timeoutInterval = request.timeInterval()
        os_log("\(baseUrl)")
        return newRequest
    }
    
    // MARK: - Private
    
    private func obtainParameters(from parameters: [AnyHashable: Any]) -> [String: CustomStringConvertible] {
        var result = [String: String]()
        parameters.forEach { key, value in
            guard
                let encodedKey = encodeKey(key),
                let encodedValue = encodeValue(value)
            else {
                return
            }
            result[encodedKey] = encodedValue
        }
        return result
    }

    private func encodeKey(_ key: AnyHashable) -> String? {
        switch key {
        case let string as String:
            return encodedQueryCompomnent(string)
        case let convertableString as CustomStringConvertible:
            return encodedQueryCompomnent(convertableString.description)
        }
    }
    
    private func encodeValue(_ value: Any) -> String? {
        switch value {
        case let string as String:
            return encodedQueryCompomnent(string)
        case let convertableString as CustomStringConvertible:
            return encodedQueryCompomnent(convertableString.description)
        case is [String: Any], is [Any]:
            guard
                let data = try? JSONSerialization.data(
                    withJSONObject: value,
                    options: [.sortedKeys, .prettyPrinted]
                ),
                let jsonString = String(data: data, encoding: .utf8)
            else {
                return nil
            }
            return encodedQueryCompomnent(jsonString)
        default:
            return nil
        }
    }
    private func encodedQueryCompomnent(_ component: String) -> String? {
        component.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}
