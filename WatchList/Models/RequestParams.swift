//
//  RequestParams.swift
//  WatchList
//
//  Created by Kishore Kumar on 12/15/19.
//  Copyright © 2019 madrapps. All rights reserved.
//

import Foundation

enum Plot: String {
    case short
    case full
}

struct SearchParams {
    var id: String?
    var title: String?
    var type: String?
    var year: String?
    var plot: Plot?
}

struct GetMovieParams {
    var searchTerm: String
    var year: String?
    var type: String?
    var page: Int?
}
