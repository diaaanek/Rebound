//
//  CoreDataRBUserTest.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation
import XCTest
import ReboundV2
class CoreDataRBUserTest : XCTestCase, RBUserStoreSpec {
    func test_retrieve_deliversOneItem() {
        let sut = makeSUT()
        assertThatRetrieveDeliversOneItem(on: sut)
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_delete_removesOneItem() {
        let sut = makeSUT()
        assertThatDeleteRemovesOneItem(on: sut)
    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataStore{
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataStore(storeURL: storeURL)
        //trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
