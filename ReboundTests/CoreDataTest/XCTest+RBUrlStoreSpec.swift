//
//  XCTest+RBUrlStoreSpec.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/21/22.
//

import Foundation
import XCTest
import Rebound

extension RBUrlStoreSpec where Self: XCTestCase {
    
    func assertRetrieveUrlsWithLimitOfOne(sut: CoreDataStore) {
        let user = makeUser()
        let count = 1
        let exp  = expectation(description: "inserting")
        let exp2 = expectation(description: "retrieving")
        sut.insert(rbUrl: user.urls, user: user, timestamp: Date()) { result in
            if case let Result.success(user) = result {
                sut.retrieve(userId: user.userId, count: count, offset: 0) { resultedUrls in
                    if case let Result.success(urls) = resultedUrls {
                        XCTAssert(urls?.count == count)
                        XCTAssert(urls?.first!.url == "https://4.com")
                        exp.fulfill()
                    }
                }
                sut.retrieve(userId: user.userId, count: count, offset: 1) { resultedUrls in
                    if case let Result.success(urls) = resultedUrls {
                        XCTAssert(urls?.count == count)
                        XCTAssert(urls?.first!.url == "https://3.com")
                    }
                    exp2.fulfill()
                }
            }
        }
        wait(for: [exp, exp2], timeout: 1.0)
    }
    func assertInsertItemIntoList(sut: CoreDataStore) {
        let user = makeUser()
        let exp = expectation(description: "Wait for insert")
        var managedUser : LocalRBUser?
        let count = user.urls.count
        sut.insert(rbUrl: user.urls, user: user, timestamp: Date()) { result in
            if case let Result.success(localUser) = result {
                managedUser = localUser
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1)
        let exp2 = expectation(description: "Wait for insert")
        var managedUrl: LocalRBUrl?
        sut.insert(rbUrl: LocalRBUrl(urlId: "9", isPrimary: true, createdDate: Date().addingTimeInterval(6), url: "https://9.com", state: 0), userId: managedUser!.userId) { result in
            if case let Result.success(localUrl) = result {
                managedUrl = localUrl
                exp2.fulfill()
            }
        }
        wait(for: [exp2], timeout: 1)
        let exp4 = expectation(description: "Wait for delete")
        
        sut.retrieve(userId: managedUser!.userId, count: count+1, offset: 0) { result in
            if case let Result.success(localUrls) = result {
                XCTAssert(localUrls!.count == count+1)
                XCTAssert(localUrls!.first!.url == managedUrl?.url)
                exp4.fulfill()
            }
        }
        wait(for:[exp4], timeout: 1)
        
    }
    func assertRetrievePrimary(sut: CoreDataStore) {
        var user = makeUser()
        let count = user.urls.count
        let exp  = expectation(description: "inserting")
        var managedUser : LocalRBUser?
        user.urls.append(LocalRBUrl(urlId: "2", isPrimary: false, createdDate: Date(), url: "https://21.com", state: 0))
        sut.insert(rbUrl: user.urls, user: user, timestamp: Date()) { result in
            if case let Result.success(user) = result {
                managedUser = user
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
        
        let exp2 = expectation(description: "retrieving Primary")
        sut.retrievePrimary(userId: managedUser!.userId) { resultedUrls in
            if case let Result.success(urls) = resultedUrls {
                XCTAssert(urls?.count == count)
                exp2.fulfill()
            }
        }
        wait(for: [exp2], timeout: 1.0)
    }
    
    func assertDeleteItem(sut: CoreDataStore) {
        let user = makeUser()
        let exp = expectation(description: "Wait for insert")
        var managedUser : LocalRBUser?
        let count = user.urls.count
        sut.insert(rbUrl: user.urls, user: user, timestamp: Date()) { result in
            if case let Result.success(localUser) = result {
                managedUser = localUser
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1)
        let exp2 = expectation(description: "Wait for insert")
        var managedUrl: LocalRBUrl?
        sut.insert(rbUrl: LocalRBUrl(urlId: "9", isPrimary: true, createdDate: Date(), url: "https://9.com", state: 0), userId: managedUser!.userId) { result in
            if case let Result.success(localUrl) = result {
                managedUrl = localUrl
                exp2.fulfill()
            }
        }
        wait(for: [exp2], timeout: 1)
        let exp3 = expectation(description: "Wait for delete")
        
        sut.deleteItem(objectId: managedUrl!.urlId) { result in
            if case Result.success() = result {
                exp3.fulfill()
            }
        }
        wait(for: [exp3], timeout: 1)
        let exp4 = expectation(description: "Wait for delete")
        
        sut.retrieve(userId: managedUser!.userId, count: count+1, offset: 0) { result in
            if case let Result.success(localUrls) = result {
                XCTAssert(localUrls!.count == count)
                exp4.fulfill()
            }
        }
        wait(for:[exp4], timeout: 1)
    }
    
    func makeUser() -> LocalRBUser {
        let list = [LocalRBUrl(urlId:"1", isPrimary: true, createdDate: Date(), url: "https://1.com", state: 0),LocalRBUrl(urlId:"2", isPrimary: true, createdDate: Date().addingTimeInterval(1), url: "https://2.com", state: 0),LocalRBUrl(urlId:"1", isPrimary: true, createdDate: Date().addingTimeInterval(2), url: "https://3.com", state: 0),LocalRBUrl(urlId:"1", isPrimary: true, createdDate: Date().addingTimeInterval(3), url: "https://4.com", state: 0)]
        var user = LocalRBUser(userId:"1", userName: "itsEthanKeiser", createdDate: Date())
        user.urls = list
        return user
    }
}
