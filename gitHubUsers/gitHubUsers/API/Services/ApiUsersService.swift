//
//  ApiUsersService.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 09.05.2022.
//

import Foundation

protocol IApiUsersService: AnyObject {
    
    @discardableResult
    func loadUsers(
        page: Int,
        searchText: String?,
        completion: @escaping (Result<PaginatedList<UserApiModel>, Swift.Error>) -> Void
    ) -> Cancellable?
}

protocol IApiUserService: AnyObject {
    
    @discardableResult
    func loadUser(
        username: String,
        completion: @escaping (Result<UserDetailsApiModel, Swift.Error>) -> Void
    ) -> Cancellable?
}

private enum Constants {
    static let pageCount = 40
}

struct PaginatedList<Model> {
    let items: [Model]
    let isLatPage: Bool
}

final class ApiUsersService {
    
    // Dependencies
    private let requestProcessor: IRequestProcessor
    private let usersListParser = UsersListParser().typeErased()
    private let userDetailsParser = UserDetailsParser().typeErased()
    
    // MARK: - Init
    
    init(
        requestProcessor: IRequestProcessor
    ) {
        self.requestProcessor = requestProcessor
    }
}

extension ApiUsersService: IApiUsersService {
    
    func loadUsers(
        page: Int,
        searchText: String?,
        completion: @escaping (Result<PaginatedList<UserApiModel>, Swift.Error>) -> Void
    ) -> Cancellable? {
        let request = UsersListRequest(
            pageCount: Constants.pageCount,
            page: page,
            searchText: searchText
        )
        return requestProcessor.execute(
            request: request,
            parser: usersListParser,
            completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let (list, headers)):
                    completion(
                        .success(
                            PaginatedList(
                                items: list.items,
                                isLatPage: self.isLastPage(from: headers["Link"] as? String)
                            )
                        )
                    )
                }
            }
        )
    }
    
    // In such type of pagination it would be better to use full url for pagination.
    // But for current goals this solution will be enought.
    private func isLastPage(from url: String?) -> Bool {
        if url?.contains("rel=\"next\"") ?? false {
            return false
        }
        return true
    }
}

// MARK: - IApiUserService

extension ApiUsersService: IApiUserService {

    func loadUser(
        username: String,
        completion: @escaping (Result<UserDetailsApiModel, Swift.Error>) -> Void
    ) -> Cancellable? {
        let request = UserRequest(
            username: username
        )
        return requestProcessor.execute(
            request: request,
            parser: userDetailsParser,
            completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let (item, _)):
                    completion(
                        .success(item)
                    )
                }
            }
        )
    }
}
