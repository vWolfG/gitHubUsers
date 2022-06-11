//
//  ApiUsersServiceTests.swift
//  gitHubUsersTests
//
//  Created by Veronika Goreva on 11.06.2022.
//

import XCTest
@testable import gitHubUsers

final class ApiUsersServiceTests: XCTestCase {
    
    // Dependencies
    private var service: ApiUsersService!
    private var requestProcessorMock: IRequestProcessorMock!
    
    override func setUp() {
        super.setUp()
        requestProcessorMock = IRequestProcessorMock()
        service = ApiUsersService(requestProcessor: requestProcessorMock)
    }
    
    override func tearDown() {
        super.tearDown()
        service = nil
        requestProcessorMock = nil
    }
    
    func test_usersListRequestWithoutSearch() throws {
        // given
        let searchText = ""
        let page = 1
        
        // when
        _ = service.loadUsers(page: page, searchText: searchText) { _ in }
        
        // then
        let request = try XCTUnwrap(requestProcessorMock.invokedExecuteParameters?.request)
        let parameters = request.parameters()
        XCTAssertEqual(request.domen(), "https://api.github.com")
        XCTAssertEqual(request.extraPath(), "/search/users")
        XCTAssertEqual(parameters.count, 3)
        XCTAssertEqual(parameters["page"] as? Int, page)
        XCTAssertEqual(parameters["per_page"] as? Int, 40)
        XCTAssertEqual(parameters["q"] as? String, "sort:followers")
        
    }
    
    func test_usersListRequest() throws {
        // given
        let searchText = "searchText"
        let page = 1
        
        // when
        _ = service.loadUsers(page: page, searchText: searchText) { _ in }
        
        // then
        let request = try XCTUnwrap(requestProcessorMock.invokedExecuteParameters?.request)
        let parameters = request.parameters()
        XCTAssertEqual(request.domen(), "https://api.github.com")
        XCTAssertEqual(request.extraPath(), "/search/users")
        XCTAssertEqual(parameters.count, 3)
        XCTAssertEqual(parameters["page"] as? Int, page)
        XCTAssertEqual(parameters["per_page"] as? Int, 40)
        XCTAssertEqual(parameters["q"] as? String, searchText)
    }
    
    func test_userDetailsRequest() throws {
        // given
        let username = "username1"
        
        // when
        _ = service.loadUser(username: username, completion: { _ in })
        
        // then
        let request = try XCTUnwrap(requestProcessorMock.invokedExecuteParameters?.request)
        let parameters = request.parameters()
        XCTAssertEqual(request.domen(), "https://api.github.com")
        XCTAssertEqual(request.extraPath(), "/users/username1")
        XCTAssertTrue(parameters.isEmpty)
    }
}
