//
//  AuthenticationService.swift
//  Marble-API-iOS
//
//  Created by Rameez on 11/27/19.
//

import Foundation
import RxSwift

protocol AuthenticationServiceType {
    func login(_ userName: String, password: String) -> Single<LoginResponseData>
    func logout() -> Single<EmptyResponse>
}

class AuthenticationService: AuthenticationServiceType {
    
    let router = Router<AuthenticationEndPoint>()

    func login(_ userName: String, password: String) -> Single<LoginResponseData> {
        
        return ApiRequest<LoginResponseData>.apiRequest { observer in
            self.router.request(.login(userName, password: password),
                           dataResponder: ApiDataResponder<LoginResponseData>.init(observer: observer))
        }
    }
    
    func logout() -> Single<EmptyResponse> {
        return ApiRequest<EmptyResponse>.apiRequest { (observer) in
            self.router.request(.logout, dataResponder: ApiDataResponder<EmptyResponse>.init(observer: observer))
        }
    }
}

