//
//  ArtworkService.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation

enum NetworkError: Error {
    case unknownUrl
    case invalidServerResponse
}

private enum ArtworkApi {
    case getArtworks
    case getArtist(_ id: String)
    
    var url: String {
        switch self {
        case .getArtworks: return "https://api.artic.edu/api/v1/artworks"
        case .getArtist(let id): return "https://api.artic.edu/api/v1/artworks/\(id)"
        }
    }
}

protocol ArtworkService: AnyObject {
    func getArtworksByPage(_ page: Int) async throws -> Artwork
    func getArtistData(_ artistId: String) async throws -> Artist
}

final class ArtworkServiceImpl: ArtworkService {
    func getArtistData(_ artistId: String) async throws -> Artist {
        try await request(.getArtist(artistId))
    }
    
    func getArtworksByPage(_ page: Int) async throws -> Artwork {
        try await request(.getArtworks)
    }
    
    private func request<T: Decodable>(_ url: ArtworkApi) async throws -> T {
        guard let url = URL(string: url.url) else { throw NetworkError.unknownUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpsResponse = response as? HTTPURLResponse,
              httpsResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            debugPrint(error)
            throw error
        }
    }
}
