//
//  XCTest+RBUserStoreSpec.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation
import XCTest
import Rebound
extension RBUserStoreSpec where Self: XCTestCase {
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: CoreDataStore, file: StaticString = #file, line: UInt = #line) {
        let user = makeUser()
        let result = insert((user, user.urls, Date()), to: sut )
        XCTAssertNil(result.1, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatRetrieveDeliversOneItem(on sut: CoreDataStore, file: StaticString = #file, line: UInt = #line) {
        
        let user = makeUser()
        insert((user, user.urls, Date()), to: sut )
        expect(store: sut, toRetrieve: .success([user]))
    }
    
    func assertThatDeleteRemovesOneItem(on sut: CoreDataStore, file: StaticString = #file, line: UInt = #line) {
        let user = makeUser()
        let result = insert((user, user.urls, Date()), to: sut)
        XCTAssertNil(result.1, "Expected to insert User successfully", file: file, line: line)
        let userId = result.0!.userId
        let deletionError = delete(userId, store: sut)
        XCTAssertNil(deletionError, "Expected to delete User successfully", file: file, line: line)
    }
    
    
    func delete(_ userId:String, store:CoreDataStore) -> Error? {
        let exp = expectation(description: "Wait for deletion")
        var deletionError : Error?
        store.deleteItem(objectId: userId) { result in
            if case let Result.failure(error) = result {
                deletionError = error
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    @discardableResult
    func insert(_ user: (user: LocalRBUser, urls: [LocalRBUrl] , timestamp: Date), to sut: CoreDataStore) -> (LocalRBUser?,Error?) {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        var insertedUser : LocalRBUser?
        sut.insert(rbUrl: user.urls, user: user.user, timestamp: user.timestamp) { result in
            if case let Result.failure(error) = result { insertionError = error }
            if case let Result.success(user) = result {
                insertedUser = user
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return (insertedUser,insertionError)
    }
    func expect(store sut: CoreDataStore, toRetrieve expectedResult: Result<[LocalRBUser]?,Error>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieve")
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
                
            case (.success(.none), .success(.none)):
                break
                
            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(retrieved.count, expected.count, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func makeUser() -> LocalRBUser {
        let list = [LocalRBUrl(urlId:"1", isPrimary: true, createdDate: Date(), url: "https://google.com", state: 0)]
        var user = LocalRBUser(userId:"1", userName: "itsEthanKeiser", createdDate: Date())
        user.urls = list
        return user
    }
}


