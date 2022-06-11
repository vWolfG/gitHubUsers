//
//  UserDetailsParser.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 11.06.2022.
//

import Foundation

final class UserDetailsParser: IParser {
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func parse(_ data: Data) throws -> UserDetailsApiModel {
        return try jsonDecoder.decode(Model.self, from: data)
    }
}
