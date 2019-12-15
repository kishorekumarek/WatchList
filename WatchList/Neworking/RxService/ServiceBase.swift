//
//  ServiceBase.swift
//  Marble-API-iOS
//
//  Created by Kishore Kumar on 11/26/19.
//

import Foundation
import RxSwift

/*
 Api Response Handling
 */

protocol DataResponderType {
    associatedtype Element: Mappable
    
    var observer: ((SingleEvent<Element>) -> Void)? { get set }
    
    init(observer: @escaping (SingleEvent<Element>) -> Void)
    init(success: @escaping (Element) -> Void, error: @escaping (Error) -> Void)
    func bytes(_ responseData: Data)
}


class ApiDataResponder<Element: Mappable>: DataResponderType {
    
    var observer: ((SingleEvent<Element>) -> Void)?
    
    var successBlock: ((Element) -> Void)?
    var errorBlock: ((Error) -> Void)?
    
    private init() {
        
    }
    
    required init(observer: @escaping (SingleEvent<Element>) -> Void) {
        self.observer = observer
    }
    
    required init(success: @escaping (Element) -> Void,
                  error: @escaping (Error) -> Void) {
        self.successBlock = success
        self.errorBlock = error
    }
    
    func bytes(_ responseData: Data) {
        let decoder = JSONDecoder()
        do {
            let element = try decoder.decode(Element.self, from: responseData)
            observer?(.success(element))
            successBlock?(element)
        } catch {
            print(error)
            observer?(.error(error))
            errorBlock?(error)
        }
    }
    
    func error(error: Error) {
        observer?(.error(error))
        errorBlock?(error)
    }
    
}

/*
 Create Single for Api Request
 */

class ApiRequest<Element: Mappable>  {
    
    typealias SingleObserver = (SingleEvent<Element>) -> Void
    
    static func apiRequest(req: @escaping (@escaping SingleObserver) -> Void) -> Single<Element> {
        let globalScheduler = ConcurrentDispatchQueueScheduler(queue:
            DispatchQueue.global())
        return Single.create(subscribe: { observer in
            req(observer)
            return Disposables.create {
                
            }
        }).subscribeOn(globalScheduler)
            .observeOn(MainScheduler.asyncInstance)
    }
}
