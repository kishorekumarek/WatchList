//
//  DashboardService.swift
//  Marble-API-iOS
//
//  Created by Kishore Kumar on 11/26/19.
//

import Foundation
import RxSwift


protocol DashboardServiceType {
    func fetchList(_ pageSize: Int) -> Single<DashboardList>
    func fetchData(_ id: String) -> Single<VisualizationData>
}

class DashboardService: DashboardServiceType {
    let router = Router<DashboardEndPoint>()
    
    func fetchList(_ pageSize: Int) -> Single<DashboardList> {
        return ApiRequest<DashboardList>.apiRequest {observer in
            self.router.request(.list(page: pageSize),
                                dataResponder: ApiDataResponder<DashboardList>.init(observer: observer))
        }
    }
    
    func fetchData(_ id: String) -> Single<VisualizationData> {
        return ApiRequest<VisualizationData>.apiRequest {observer in
            self.router.request(.dashboard(id: id),
                                dataResponder: ApiDataResponder<VisualizationData>.init(observer: observer))
        }
    }
}
