//
//  UserApiModel.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 09.05.2022.
//

import Foundation

struct UsersList: Codable {
    let items: [UserApiModel]
}

struct UserApiModel: Codable {
    let id: Int
    let login: String
    let avatarUrl: String?
}
