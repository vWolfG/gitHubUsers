//
//  IRequest.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import Foundation

protocol IRequest: AnyObject {
    
    func domen() -> String
    func extraPath() -> String?
    func headers() -> [String: String]
    func parameters() -> [AnyHashable: Any]
    func body() -> Data?
    func method() -> HttpMethod
    func timeInterval() -> TimeInterval
    func needToken() -> Bool
    func tokenKey() -> String
}

enum HttpMethod: String {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
