//
//  CoreDataRBUrlTest.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/21/22.
//

import Foundation
import XCTest
import Rebound

class CoreDataRBUrlTest: XCTestCase, RBUrlStoreSpec {
    func test_delete_success() {
        let sut = makeSUT()
        assertDeleteItem(sut: sut)
    }
    
    func test_retrieve_UrlsWithLimitOfOne() {
        let sut = makeSUT()
        assertRetrieveUrlsWithLimitOfOne(sut: sut)
    }
    func test_insert_oneItemIntoList() {
        let sut = makeSUT()
        assertInsertItemIntoList(sut: sut)
    }
    func test_retrieve_primary() {
        let sut = makeSUT()
        assertRetrievePrimary(sut:sut)
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataStore{
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataStore(storeURL: storeURL)
        //trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
