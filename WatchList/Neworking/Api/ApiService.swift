//
//  ApiService.swift
//  Marble-API-iOS
//
//  Created by Kishore Kumar on 11/26/19.
//

import Foundation
import RxSwift

public protocol Mappable: Decodable {
    
}

public struct DashboardData: Mappable {
    
}

public struct LoginResponseData: Mappable {
    var username: String
    
    init(username: String) {
        self.username   =   username
    }
    
    enum CodingKeys: String, CodingKey {
        case username   =   "username"
    }
}

public struct EmptyResponse: Mappable {
}

public struct ApiResponse: Mappable {
    var isSuccess: Bool
    var message: String
}

public enum ApiScheme: String {
    case http, https
}

//http://www.omdbapi.com/?i=tt3896198&apikey=b4af551c


public struct ApiConfig {
    let baseUrl: String
    let scheme: ApiScheme
    
    public init(scheme: ApiScheme, baseUrl: String) {
        self.scheme = scheme
        self.baseUrl = baseUrl
    }
}

extension ApiConfig {
    var url: URL? {
        return URL(string: scheme.rawValue + "://" + baseUrl)
    }
}

public class ApiService {
    let config = ApiConfig(scheme: .http, baseUrl: "www.omdbapi.com?apikey=b4af551c")
    public static let service = ApiService(config: config)
    
    static var config: ApiConfig!

    public required init(config: ApiConfig) {
        ApiService.config = config
    }

}
//http://www.omdbapi.com/?i=tt3896198&apikey=b4af551c

