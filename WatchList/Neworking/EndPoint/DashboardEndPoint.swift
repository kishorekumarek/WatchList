//
//  DashboardEndPoint.swift
//  Marble-API-iOS
//
//  Created by Kishore Kumar on 11/26/19.
//

import Foundation


enum DashboardEndPoint {
    case list(page: Int)
    case dashboard(id: String)
}

extension DashboardEndPoint: EndPointType {
        
    var path: String {
        switch self {
        case .list:
            return "api/dashboard/list"
        case .dashboard:
            return "api/visualization-data"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .dashboard:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .list(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["pageSize":page])
        case .dashboard(let id):
            return .requestParametersAndHeaders(bodyParameters: ["id" : id],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: [:],
                                      additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .list:
            return nil
        case .dashboard:
            return ["kbn-xsrf" : "reporting"]
        }
    }
}
