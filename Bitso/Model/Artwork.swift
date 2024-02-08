//
//  ArtworkData.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation

struct Artwork: Codable {
    var pagination: Pagination
    var data: [Data] = []
    
    struct Data: Codable {
        let id: Int
        let title: String
        let thumbnail: Thumbnail?
        let artistTitle: String?
        let description: String?
        let imageId: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case thumbnail
            case artistTitle = "artist_title"
            case description
            case imageId = "image_id"
        }
    }
}

struct Pagination: Codable {
    let total: Int
    let limit: Int
    let offset: Int
    let totalPages: Int
    let currentPage: Int
    
    enum CodingKeys: String, CodingKey {
        case total
        case limit
        case offset
        case totalPages = "total_pages"
        case currentPage = "current_page"
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
