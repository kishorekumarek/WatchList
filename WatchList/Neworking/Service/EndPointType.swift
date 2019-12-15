//
//  EndPointType.swift
//  Marble-API-iOS
//
//  Created by Rameez on 11/17/19.
//  Copyright © 2019 Rameez. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseUrl: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    var baseUrl: URL {
        guard let url = ApiService.config.url else { fatalError("baseURL could not be configured.")}
        return url
    }
}
