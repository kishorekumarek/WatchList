//
//  MovieEndPoint.swift
//  Marble-API-iOS
//
//  Created by Rameez on 11/27/19.
//

import Foundation

enum MovieEndPoint {
    case getMovie(_ params: GetMovieParams)
    case search(_ params: SearchParams)
}

extension MovieEndPoint: EndPointType {
    var path: String? {
        return nil
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .getMovie(let params):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: formGetMovieUrlParams(params: params))
        case .search(let params):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: formSearchParams(params: params))

        }
    }
    
    
    var headers: HTTPHeaders? {
        return nil
    }
    
   private func formGetMovieUrlParams(params: GetMovieParams) -> [String : String] {
        var paramsDict: [String : String] = [:]
        paramsDict["s"] = params.searchTerm
        if let type = params.type {
            paramsDict["type"] = type
        }
        if let year = params.year {
            paramsDict["year"] = year
        }
        if let page = params.page {
            paramsDict["page"] = String(page)
        }
        return paramsDict
    }
    
   private func formSearchParams(params: SearchParams) -> [String : String] {

        var paramsDict: [String : String] = [:]
        if let id = params.id {
            paramsDict["i"] = id
        }
        
        if let title = params.title {
            paramsDict["t"] = title
        }
        
        if let type = params.type {
            paramsDict["type"] = type
        }
        
        if let year = params.year {
            paramsDict["y"] = year
        }
        
        return paramsDict
    }
}
