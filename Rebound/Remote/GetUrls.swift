//
//  GetUrls.swift
//  Rebound
//
//  Created by Ethan Keiser on 4/7/22.
//

import Foundation

public class GetUrls {
    let url = "https://444xmwygee.execute-api.us-east-1.amazonaws.com/Production/url"
    let httpClient : HttpClient
    
    private struct UserModel: Codable {
        let userName: String
        let user_id: Int
    }
    private struct GetModel: Codable {
        let urlstatus_id: Int
        let lastViewed: Date?
        let creationDate: Date
        let urlString: String
        let isShown: Bool
        let lastModified: Date
        let primaryUser: UserModel
    }

    public init(httpClient :HttpClient) {
        self.httpClient = httpClient
    }
    public func getUrls(ig_id: String, completion: @escaping (Result<[RemoteRBUser], Error>) -> Void) {
            httpClient.get(urlString: url+"?ig_id=\(ig_id)") { result in
                switch result {
                case .success(let data, let response):
                    var decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.customDate)
                    var model: [GetModel] = try! decoder.decode([GetModel].self, from: data) as! [GetModel]
                    var userDict = [Int: RemoteRBUser]()
                    for item in model {
                        userDict[item.primaryUser.user_id, default: RemoteRBUser(userId: String(item.primaryUser.user_id), userName: item.primaryUser.userName, createdDate: Date())].urls.append(RemoteRBUrl(urlStatusId: item.urlstatus_id, isPrimary: true, createdDate: item.creationDate, url: item.urlString, state: item.isShown, lastModified: item.lastModified, viewedLastModified: item.lastViewed))
                    }
                    completion(.success(Array(userDict.values)))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
extension DateFormatter {
  static let customDate: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
