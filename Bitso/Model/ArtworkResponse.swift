//
//  ArtworkData.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation

struct ArtworkResponse: Codable {
    var pagination: Pagination?
    var data: [Artwork] = []
}

struct Artwork: Codable {
    let id: Int
    let title: String
    let thumbnail: Thumbnail?
    let artistTitle: String?
    let description: String?
    let imageId: String?
    let artistId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
        case artistTitle = "artist_title"
        case description
        case imageId = "image_id"
        case artistId = "artist_id"
    }
}

struct Pagination: Codable {
    let total: Int
    let limit: Int
    let offset: Int
    let totalPages: Int
    let currentPage: Int
    
    var nextPage: Int { currentPage + 1 }
    
    enum CodingKeys: String, CodingKey {
        case total
        case limit
        case offset
        case totalPages = "total_pages"
        case currentPage = "current_page"
    }
    
    static func initial() -> Pagination {
        Pagination(total: 0, limit: 12, offset: 0, totalPages: 0, currentPage: 0)
    }
}

struct Thumbnail: Codable {
    var lqip: String
    var altText: String

    enum CodingKeys: String, CodingKey {
        case lqip
        case altText = "alt_text"
    }
}
