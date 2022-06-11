//
//  UserDetailsApiModel.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 05.06.2022.
//

import Foundation

struct UserDetailsApiModel: Codable {
    let name: String?
    let bio: String?
    let avatarUrl: String?
    let company: String?
    let email: String?
    let followers: Int?
}
