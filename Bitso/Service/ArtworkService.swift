//
//  ArtworkService.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation
import Factory

enum NetworkError: Error {
    case unknownUrl
    case invalidHttpResponse
    case invalidServerResponse
}

enum ArtworkApi {
    case getArtworks(_ page: Int)
    case getArtist(_ id: Int)
    case image(_ resourceId: String)
    
    var url: String {
        switch self {
        case .getArtworks(let page): return "https://api.artic.edu/api/v1/artworks?fields=title,id,artist_title,description,image_id,artist_id&page=\(page)"
        case .getArtist(let id): return "https://api.artic.edu/api/v1/artists/\(id)"
        case .image(let resourceId): return "https://www.artic.edu/iiif/2/\(resourceId)/full/843,/0/default.jpg"
        }
    }
}

protocol ArtworkService: AnyObject {
    func getArtworksByPage(_ page: Int) async throws -> ArtworkResponse
    func getArtistData(_ artistId: Int) async throws -> Artist
}

final class ArtworkServiceImpl: ArtworkService {
    
    @Injected(\.artistCache) private var artistCache
    @Injected(\.artworkCache) private var artworkCache

    func getArtistData(_ artistId: Int) async throws -> Artist {
        if let cachedArtist = artistCache[artistId] { return cachedArtist }
        
        do {
            let artist: Artist = try await request(.getArtist(artistId))
            artistCache[artistId] = artist
            try artistCache.saveToDisk(withName: .artist)
            return artist
        } catch let error {
            throw error
        }
    }
    
    func getArtworksByPage(_ page: Int) async throws -> ArtworkResponse {
        if let cachedArtwork = artworkCache[page] {
            return cachedArtwork
        }
        
        do {
            let response: ArtworkResponse = try await request(.getArtworks(page))
            // For the artwork array the cache strategy uses the page as the key
            artworkCache[page] = response
            try artworkCache.saveToDisk(withName: .artwork)
            return response
        } catch let error { throw error }
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
