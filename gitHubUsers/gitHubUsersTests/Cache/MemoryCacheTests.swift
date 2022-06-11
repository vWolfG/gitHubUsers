//
//  MemoryCacheTests.swift
//  gitHubUsersTests
//
//  Created by Veronika Goreva on 11.06.2022.
//

import XCTest
@testable import gitHubUsers

final class MemoryCacheTests: XCTestCase {
    
    // Dependencies
    private var cahce: MemoryCache<String>!
    
    override func setUp() {
        super.setUp()
        cahce = MemoryCache(maxSize: 10)
    }
    
    override func tearDown() {
        super.tearDown()
        cahce = nil
    }

    func test_saveFetchtotalSize() throws {
        // Check saving and fetching data
        // given
        let some1 = "Some1"
        let some2 = "Some2"
        
        // when
        cahce.save(some1, key: some1)
        cahce.save(some2, key: some2)
        
        // then
        XCTAssertEqual(cahce.fetch(by: some1), some1)
        XCTAssertEqual(cahce.fetch(by: some2), some2)
        XCTAssertEqual(cahce.totalSize, some1.count + some2.count)
    }
    
    func test_sizeClearing() throws {
        // Check size restirction
        // given
        let some1 = "Some1"
        let some2 = "Some2"
        let some3 = "Some3"
        
        // when
        cahce.save(some1, key: some1)
        cahce.save(some2, key: some2)
        cahce.save(some3, key: some3)
        
        // then
        XCTAssertNil(cahce.fetch(by: some1))
        XCTAssertEqual(cahce.fetch(by: some2), some2)
        XCTAssertEqual(cahce.fetch(by: some3), some3)
        XCTAssertEqual(cahce.totalSize, some2.count + some3.count)
    }
}

extension String: ValueSizeDeterminable, CacheKeyProvader {
   public var key: String { self }
}
