//
//  UsersListRequest.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 09.05.2022.
//

import Foundation

final class UsersListRequest: BaseRequest {
    
    private let pageCount: Int
    private let page: Int
    private let searchText: String?
    
    // MARK: - Private

    init(
        pageCount: Int,
        page: Int,
        searchText: String?
    ) {
        self.pageCount = pageCount
        self.page = page
        self.searchText = searchText
    }
    
    // MARK: - IRequest

    override func extraPath() -> String? {
        "/search/users"
    }
    
    override func parameters() -> [AnyHashable : Any] {
        var parameters =  [AnyHashable : Any]()
        parameters["page"] = page
        parameters["per_page"] = pageCount
        parameters["q"] = searchText?.nonBlankOrNil() ?? "sort:followers"
        return parameters
    }
}
