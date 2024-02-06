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

private enum ArtworkApi: String {
    case getArtworks = "https://api.artic.edu/api/v1/artworks"
}

protocol ArtworkService: AnyObject {
    func getArtworksByPage(_ page: Int) async throws -> ArtworkData
}

final class ArtworkServiceImpl: ArtworkService {
    func getArtworksByPage(_ page: Int) async throws -> ArtworkData {
        // TODO: Implement NetworkService
        guard let url = URL(string: ArtworkApi.getArtworks.rawValue) else {
            throw NetworkError.unknownUrl
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpsResponse = response as? HTTPURLResponse,
              httpsResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        
        do {
            return try JSONDecoder().decode(ArtworkData.self, from: data)
        } catch let error as DecodingError {
            debugPrint(error)
            throw error
        }
    }
}
