//
//  Router.swift
//  Marble-API-iOS
//
//  Created by Rameez on 11/19/19.
//  Copyright © 2019 Rameez. All rights reserved.
//

import Foundation
import RxSwift

enum ApiError: Error {
    case empty
}
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request<Element: Mappable>(_ route: EndPoint, dataResponder: ApiDataResponder<Element>)
    func cancel()
}

class Router<EndPoint: EndPointType>: NSObject, NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request<Element: Mappable>(_ route: EndPoint, dataResponder: ApiDataResponder<Element>) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let responseData = data {
                    dataResponder.bytes(responseData)
                } else if let responseError = error {
                    dataResponder.error(error: responseError)
                } else {
                    dataResponder.error(error: ApiError.empty)
                }
                })
            task?.resume()
        } catch  {
            dataResponder.error(error: error)
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var url = route.baseUrl
        if let path = route.path {
            url = url.appendingPathComponent(path)
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod  =   route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch  {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }

    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

}
