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

protocol ApiServiceType {
    static var config: ApiConfig! { get set }
    
    init(config: ApiConfig)
    func fetchList(_ pageSize: Int) -> Single<DashboardList>
    func fetchVisualizationData(_ id: String) -> Single<VisualizationData>
    
    //Login API's
    func login(_ userName: String, password: String) -> Single<LoginResponseData>
    func logout() -> Single<EmptyResponse>
}

public class ApiService: ApiServiceType {
    let config = ApiConfig(scheme: .http, baseUrl: "www.omdbapi.com?apikey=b4af551c")
    public static let service = ApiService(config: config)
    
    static var config: ApiConfig!
    private let dashboardService = DashboardService()
    private let authService = AuthenticationService()

    public required init(config: ApiConfig) {
        ApiService.config = config
    }
    
    public func fetchList(_ pageSize: Int) -> Single<DashboardList> {
        return dashboardService.fetchList(pageSize)
    }
    
    public func fetchVisualizationData(_ id: String) -> Single<VisualizationData> {
        return dashboardService.fetchData(id)
    }
    
    public func login(_ userName: String, password: String) -> Single<LoginResponseData> {
        return authService.login(userName, password: password)
    }
    
    public func logout() -> Single<EmptyResponse> {
        return authService.logout()
    }

}
//http://www.omdbapi.com/?i=tt3896198&apikey=b4af551c

