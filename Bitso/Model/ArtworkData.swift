//
//  ArtworkData.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation

struct ArtworkData: Codable {
//    var pagination: Pagination
    var data: [Artwork] = []
}

//struct Pagination: Codable {
//
//}

struct Artwork: Codable {
    let id: Int
    let title: String
    let thumbnail: Thumbnail?
    let artist_title: String?
    let description: String?
    let image_id: String?
}

struct Thumbnail: Codable {
    var lqip: String
    var altText: String

    enum CodingKeys: String, CodingKey {
        case lqip
        case altText = "alt_text"
    }
}
