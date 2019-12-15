//
//  VisualizationData.swift
//  Marble-API-iOS
//
//  Created by Kishore Kumar on 12/4/19.
//

import Foundation

// MARK: - VisualizationData
public struct VisualizationData: Decodable, Mappable {
    public let dataList: [VisualizationDatum]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.dataList = try container.decode([VisualizationDatum].self)
    }
}

// MARK: - VisualizationDatum
public struct VisualizationDatum: Decodable {
    public let took: Int
    public let timedOut: Bool
    public let shards: Shards
    public let hits: Hits
    private var aggregations: [String: Aggregation]?
    public let status: Int

    enum CodingKeys: String, CodingKey {
        case aggregations
        case took
        case timedOut = "timed_out"
        case hits
        case status
        case shards = "_shards"
    }
}

extension VisualizationDatum {
    public var aggregation: Aggregation? {
        return aggregations?.values.first
    }
}

public struct Bucket: Decodable {
    public var agg:  Aggregation?
    public let key: String
    public let docCount: Int
    
    
    enum CodingKeys: String, CodingKey {
        case key
        case docCount = "doc_count"
        
        static var keys: [String] {
            return [CodingKeys.key.rawValue, CodingKeys.docCount.rawValue]
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(String.self, forKey: Bucket.CodingKeys.key)
        self.docCount = try container.decode(Int.self, forKey: Bucket.CodingKeys.docCount)
        
        //Dynamic Key for aggregation
        let dynamicContainer = try decoder.container(keyedBy: DynamicKey.self)
        let filtered = dynamicContainer.allKeys.first(where:{ CodingKeys.keys.contains($0.stringValue) == false})
        if let key = filtered {
            self.agg = try dynamicContainer.decodeIfPresent(Aggregation.self, forKey: key)
        }
    }
}

public struct Aggregation: Decodable {
    public let docCountErrorUpperBound: Int
    public let sumOtherDocCount: Int
    public let buckets: [Bucket]
    
    enum CodingKeys: String, CodingKey {
        case docCountErrorUpperBound = "doc_count_error_upper_bound"
        case sumOtherDocCount = "sum_other_doc_count"
        case buckets
    }
    
}

// MARK: - Hits
public struct Hits: Decodable {
    public let total, maxScore: Int
    public let hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case total
        case maxScore = "max_score"
        case hits
    }

    public init(total: Int, maxScore: Int, hits: [Hit]) {
        self.total = total
        self.maxScore = maxScore
        self.hits = hits
    }
}

// MARK: - Hit
public struct Hit: Decodable {
    public let index, type, id: String
    public let score: Int
    public let source: Source

    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case score = "_score"
        case source = "_source"
    }

    public init(index: String, type: String, id: String, score: Int, source: Source) {
        self.index = index
        self.type = type
        self.id = id
        self.score = score
        self.source = source
    }
}

// MARK: - Source
public struct Source: Decodable {
    public let type, recordID, updatedAt: String
    public let itemOfInterest: Bool
    public let text, createdAt, kibanaDate, dataFileName: String
    public let htmlText: String
    public let language, languageCode: String?
    public let originalLink: String
    public let author: Author
    public let boardMessage: BoardMessage?
    public let source: SourceClass
    public let entity: [Entity]
    public let sentiment: String
    public let disqus: Disqus?

    enum CodingKeys: String, CodingKey {
        case type
        case recordID = "record_id"
        case updatedAt = "updated_at"
        case itemOfInterest = "item_of_interest"
        case text
        case createdAt = "created_at"
        case kibanaDate = "kibana_date"
        case dataFileName = "data_file_name"
        case htmlText = "html_text"
        case language
        case languageCode = "language_code"
        case originalLink = "original_link"
        case author
        case boardMessage = "board_message"
        case source, entity, sentiment, disqus
    }

    public init(type: String, recordID: String, updatedAt: String, itemOfInterest: Bool, text: String, createdAt: String, kibanaDate: String, dataFileName: String, htmlText: String, language: String?, languageCode: String?, originalLink: String, author: Author, boardMessage: BoardMessage?, source: SourceClass, entity: [Entity], sentiment: String, disqus: Disqus?) {
        self.type = type
        self.recordID = recordID
        self.updatedAt = updatedAt
        self.itemOfInterest = itemOfInterest
        self.text = text
        self.createdAt = createdAt
        self.kibanaDate = kibanaDate
        self.dataFileName = dataFileName
        self.htmlText = htmlText
        self.language = language
        self.languageCode = languageCode
        self.originalLink = originalLink
        self.author = author
        self.boardMessage = boardMessage
        self.source = source
        self.entity = entity
        self.sentiment = sentiment
        self.disqus = disqus
    }
}

// MARK: - Author
public struct Author: Decodable {
    public let name: String
    public let profileID: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profileID = "profile_id"
    }

    public init(name: String, profileID: String?) {
        self.name = name
        self.profileID = profileID
    }
}

// MARK: - BoardMessage
public struct BoardMessage: Decodable {
    public let threadID, forumTitle: String
    public let forumLink: String

    enum CodingKeys: String, CodingKey {
        case threadID = "thread_id"
        case forumTitle = "forum_title"
        case forumLink = "forum_link"
    }

    public init(threadID: String, forumTitle: String, forumLink: String) {
        self.threadID = threadID
        self.forumTitle = forumTitle
        self.forumLink = forumLink
    }
}

// MARK: - Disqus
public struct Disqus: Decodable {
    public let parentPostID, parentPostAuthorID, parentPostAuthorIDAtSource: String
    public let threadLink: String

    enum CodingKeys: String, CodingKey {
        case parentPostID = "parent_post_id"
        case parentPostAuthorID = "parent_post_author_id"
        case parentPostAuthorIDAtSource = "parent_post_author_id_at_source"
        case threadLink = "thread_link"
    }

    public init(parentPostID: String, parentPostAuthorID: String, parentPostAuthorIDAtSource: String, threadLink: String) {
        self.parentPostID = parentPostID
        self.parentPostAuthorID = parentPostAuthorID
        self.parentPostAuthorIDAtSource = parentPostAuthorIDAtSource
        self.threadLink = threadLink
    }
}

// MARK: - Entity
public struct Entity: Decodable {
    public let name: String
    public let type: String

    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

// MARK: - SourceClass
public struct SourceClass: Decodable {
    public let name, type, domain: String
    public let link: String
    public let idAtSource: String?

    enum CodingKeys: String, CodingKey {
        case name, type, domain, link
        case idAtSource = "id_at_source"
    }

    public init(name: String, type: String, domain: String, link: String, idAtSource: String?) {
        self.name = name
        self.type = type
        self.domain = domain
        self.link = link
        self.idAtSource = idAtSource
    }
}

// MARK: - Shards
public struct Shards: Decodable {
    public let total, successful, skipped, failed: Int

    public init(total: Int, successful: Int, skipped: Int, failed: Int) {
        self.total = total
        self.successful = successful
        self.skipped = skipped
        self.failed = failed
    }
}

struct DynamicKey: CodingKey {
    var intValue: Int?
    var stringValue: String

    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
}
