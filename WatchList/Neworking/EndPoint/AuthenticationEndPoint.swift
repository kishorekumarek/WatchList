//
//  AuthenticationEndPoint.swift
//  Marble-API-iOS
//
//  Created by Rameez on 11/27/19.
//

import Foundation

enum AuthenticationEndPoint {
    case login(_ userName: String, password: String)
    case logout
}

extension AuthenticationEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .login:
            return "api/v1/auth/login"
        case .logout:
            return "api/v1/auth/logout"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var task: HTTPTask {
        switch self {
        case .login(let userName, password: let password):
            
            return .requestParametersAndHeaders(bodyParameters: ["username": userName,
                                                                 "password": password],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
        default:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["kbn-xsrf": "reporting"]
    }
    
}
