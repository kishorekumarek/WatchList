//
//  MovieList.swift
//  WatchList
//
//  Created by Kishore Kumar on 12/15/19.
//  Copyright © 2019 madrapps. All rights reserved.
//

import Foundation

public struct MovieList: Mappable {
  
    public let search: [MovieSearchResult]?
    public let totalResults, response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }

    public init(search: [MovieSearchResult]?, totalResults: String?, response: String?) {
        self.search = search
        self.totalResults = totalResults
        self.response = response
    }
}

// MARK: - Search
public struct MovieSearchResult: Mappable {
    public let title, year, imdbID, type: String?
    public let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }

    public init(title: String?, year: String?, imdbID: String?, type: String?, poster: String?) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.type = type
        self.poster = poster
    }
}
