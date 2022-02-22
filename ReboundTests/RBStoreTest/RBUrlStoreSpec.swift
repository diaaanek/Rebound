//
//  RBUrlStoreSpec.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation

protocol RBUrlStoreSpec {
    func test_retrieve_UrlsWithLimitOfOne()
    func test_delete_success()
    func test_insert_oneItemIntoList()
    func test_retrieve_primary()
}
