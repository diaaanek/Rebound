//
//  Post.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/29/22.
//

import Foundation

public protocol DeleteRbUser {
    func delete(rbUserId:String, completion:@escaping(Result<Void,Error>)->())
}

public class RemoteDeleteRbUser: DeleteRbUser {
    let client : HttpClient
    public init(client: HttpClient) {
        self.client = client
    }
    
    public func delete(rbUserId:String, completion:@escaping(Result<Void,Error>)->()) {
        let url = "https://somedestination.com/api/user/\(rbUserId)"
        self.client.delete(urlString: url) { result in
            
        }
    }
}

public protocol EditRBUser {
    func save(rbuser: RBUser, completion:@escaping(Result<[Int],Error>)->())
    func replace(rbUserId:String, rbuser: RBUser, completion:(Result<Void,Error>)->())
}

public struct PostUserModel : Codable{
    public let userName : String
    public let urls : [PostUrlModel]
    public let ig_id : String
}
public struct PostUrlModel: Codable {
    public let urlString : String
}
public class RemoteSaveRbUser: EditRBUser {
    private enum UrlPath: String {
        case save = "https://444xmwygee.execute-api.us-east-1.amazonaws.com/Production/user"
        case replace = "https://someurl/l"
    }
    
    let client : HttpClient
    let identity : String
    public init(client: HttpClient, identity: String) {
        self.identity = identity
        self.client = client
    }
    
    public func save(rbuser: RBUser, completion:@escaping (Result<[Int], Error>) -> ()) {
        let postModel = PostUserModel(userName: rbuser.userName, urls: rbuser.urls.map({ url in
            PostUrlModel(urlString: url.url)
        }), ig_id: identity)
        let encoder =  JSONEncoder()
        if let encodedBody = try? encoder.encode(postModel) {
            
            self.client.post(urlString: UrlPath.save.rawValue, body: encodedBody) { result in
                switch result {
                case .success(let data, let response):
                    let values = try! JSONDecoder().decode([Int].self, from: data)
                    completion(.success(values))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    public func replace(rbUserId: String, rbuser: RBUser, completion: (Result<Void, Error>) -> ()) {
        let encoder =  JSONEncoder()
        if let encodedBody = try? encoder.encode(Replace(rbUserId: rbUserId, rbUser: rbuser.getRemoteUser())) {
            self.client.post(urlString: UrlPath.replace.rawValue, body: encodedBody) { result in
                
            }
        }
    }
}

public class PrimaryDeleteWithRemoteStorage : DeleteRbUser {
    
    let primary: DeleteRbUser
    let secondary: DeleteRbUser
    init(primary: DeleteRbUser, secondary: DeleteRbUser) {
        self.primary = primary
        self.secondary = secondary
    }
    public func delete(rbUserId: String, completion: @escaping (Result<Void, Error>) -> ()) {
        self.primary.delete(rbUserId: rbUserId) { result in
            switch result {
            case .success(_):
                self.secondary.delete(rbUserId: rbUserId) { result in
                    completion(result)
                }
            case .failure(_):
                break
            }
        }
    }
}
public class PrimaryEditWithRemoteStorage : EditRBUser {
    
    let primary: EditRBUser
    let secondary: EditRBUser
    init(primary: EditRBUser, secondary: EditRBUser) {
        self.primary = primary
        self.secondary = secondary
    }
    
    public func save(rbuser: RBUser, completion: (Result<[Int], Error>) -> ()) {
        self.primary.save(rbuser:rbuser) { result in
            switch result {
            case .success(_):
                self.secondary.save(rbuser:rbuser) { result in
                   // completion(result)
                }
            case .failure(_):
                break
            }
        }
    }
    
    public func replace(rbUserId: String, rbuser: RBUser, completion: (Result<Void, Error>) -> ()) {
        self.primary.replace(rbUserId:rbUserId,rbuser: rbuser) { result in
            switch result {
            case .success(_):
                self.secondary.replace(rbUserId:rbUserId,rbuser: rbuser) { result in
                    completion(result)
                }
            case .failure(_):
                break
            }
        }
    }
}

