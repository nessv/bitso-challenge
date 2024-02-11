//
//  MockService.swift
//  BitsoTests
//
//  Created by Néstor Valdez on 2/10/24.
//

import Foundation
@testable import Bitso

class MockService: ArtworkService {
    func getArtworksByPage(_ page: Int) async throws -> Bitso.ArtworkResponse {
        try decodeMockResponse(ArtworkResponse.self, from: "artwork_response_page_\(page).json")
    }
    
    func getArtistData(_ artistId: Int) async throws -> Bitso.Artist {
        try decodeMockResponse(Artist.self, from: "artist_response_\(artistId).json")
    }
}

extension MockService {
    func decodeMockResponse<T: Decodable>(_ type: T.Type, 
                                          from file: String) throws -> T {
        
        try Bundle(for: Self.self).decode(type, from: file)
    }
}
