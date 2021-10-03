//
//  SearchResultModel.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/09/30.
//

import Foundation

struct SearchResult: Codable {
    let meta: Meta
    let documents: [ImageInfo]
}

struct ImageInfo: Codable {
    let thumbnailURL: String
    let imageURL: String
    let width: Int
    let height: Int
    let displaySitename: String
    let datetime: String
    
    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width, height
        case displaySitename = "display_sitename"
        case datetime
    }
}

struct Meta: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}
