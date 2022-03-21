//
//  HttpClient.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/16/22.
//

import Foundation

public protocol HttpClient {
    func getResult(urlString: String, completion: @escaping (Result<(Data,HTTPURLResponse),Error>)->Void) -> URLSessionDataTask
}
