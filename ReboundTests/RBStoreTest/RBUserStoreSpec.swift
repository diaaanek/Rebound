//
//  RBUserStoreSpec.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation

public protocol RBUserStoreSpec {
    func test_insert_deliversNoErrorOnEmptyCache()
    func test_retrieve_deliversOneItem()
    func test_delete_removesOneItem()
}
