//
//  ArtworkData.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation

struct Artwork: Codable {
//    var pagination: Pagination
    var data: [Data] = []
    
    struct Data: Codable {
        let id: Int
        let title: String
        let thumbnail: Thumbnail?
        let artist_title: String?
        let description: String?
        let image_id: String?
    }
}

//struct Pagination: Codable {
//
//}

struct Thumbnail: Codable {
    var lqip: String
    var altText: String

    enum CodingKeys: String, CodingKey {
        case lqip
        case altText = "alt_text"
    }
}
