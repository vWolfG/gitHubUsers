//
//  UserRequest.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 29.05.2022.
//

import Foundation

final class UserRequest: BaseRequest {
    
    private let username: String
    
    // MARK: - Private

    init(
        username: String
    ) {
        self.username = username
    }
    
    // MARK: - IRequest

    override func extraPath() -> String? {
        "/users/\(username)"
    }
}
