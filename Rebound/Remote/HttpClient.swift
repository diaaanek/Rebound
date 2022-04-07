//
//  HttpClient.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/16/22.
//

import Foundation

public protocol HttpClient {
    func get(urlString: String, completion: @escaping (Result<(Data,HTTPURLResponse),Error>)->Void) -> URLSessionDataTask
    func post(urlString:String, body: Data?, completion: @escaping (Result<(Data,HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask
    func delete(urlString: String, completion: @escaping (Result<(Data,HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask

}
