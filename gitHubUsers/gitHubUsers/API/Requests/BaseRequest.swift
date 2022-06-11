//
//  BaseRequest.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 09.05.2022.
//

import Foundation

class BaseRequest: IRequest {
    
    func domen() -> String {
        "https://api.github.com"
    }
    
    func extraPath() -> String? {
        nil
    }
    
    func headers() -> [String : String] {
        ["Accept": "application/vnd.github.v3+json"]
    }
    
    func parameters() -> [AnyHashable : Any] {
        [:]
    }
    
    func body() -> Data? {
        nil
    }
    
    func method() -> HttpMethod {
        .get
    }
    
    func timeInterval() -> TimeInterval {
        60
    }
    
    func needToken() -> Bool {
        true
    }
    
    func tokenKey() -> String {
        "TOKEN"
    }
}
