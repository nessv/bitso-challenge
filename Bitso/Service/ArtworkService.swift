//
//  ArtworkService.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation

enum NetworkError: Error {
    case unknownUrl
    case invalidHttpResponse
    case invalidServerResponse
}

private enum ArtworkApi {
    case getArtworks(_ page: Int)
    case getArtist(_ id: Int)
    
    var url: String {
        switch self {
        case .getArtworks(let page): return "https://api.artic.edu/api/v1/artworks?fields=title,id,artist_title,description,image_id&page=\(page)"
        case .getArtist(let id): return "https://api.artic.edu/api/v1/artists/\(id)"
        }
    }
}

protocol ArtworkService: AnyObject {
    func getArtworksByPage(_ page: Int) async throws -> Artwork
    func getArtistData(_ artistId: Int) async throws -> Artist
}

final class ArtworkServiceImpl: ArtworkService {
    func getArtistData(_ artistId: Int) async throws -> Artist {
        try await request(.getArtist(artistId))
    }
    
    func getArtworksByPage(_ page: Int) async throws -> Artwork {
        try await request(.getArtworks(page))
    }
    
    private func request<T: Decodable>(_ url: ArtworkApi) async throws -> T {
        guard let url = URL(string: url.url) else { throw NetworkError.unknownUrl }
        debugPrint("INFO: Making request to URL \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpsResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidHttpResponse
        }
        
        debugPrint("INFO: Server response was \(httpsResponse.statusCode)")
        
        guard httpsResponse.statusCode == 200 else {
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
