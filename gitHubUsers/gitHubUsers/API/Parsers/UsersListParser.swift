//
//  UsersListParser.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 09.05.2022.
//

import Foundation

final class UsersListParser: IParser {
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func parse(_ data: Data) throws -> UsersList {
        return try jsonDecoder.decode(UsersList.self, from: data)
    }
}
