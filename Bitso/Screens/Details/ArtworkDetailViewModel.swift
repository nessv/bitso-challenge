//
//  ArtworkDetailViewModel.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/8/24.
//

import Foundation
import Factory

final class ArtworkDetailViewModel: ViewModel {
    enum Action { case loadArtistInfo }
    enum State: Equatable {
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loaded(let lhsData), .loaded(let rhsData)):
                return lhsData.data.id == rhsData.data.id
                // TRUE CASES
            case (.initial, .initial),
                (.loadingArtistInfo, .loadingArtistInfo),
                (.errorLoadingArtistInfo, .errorLoadingArtistInfo),
                (.artistInfoEmpty, .artistInfoEmpty)
                : return true
                // FALSE CASES
            default: return false
            }
        }
        
        case initial
        case loadingArtistInfo
        case loaded(_ artist: Artist)
        case errorLoadingArtistInfo
        case artistInfoEmpty
    }
    
    @Published var state: State = .initial
    @Published var artwork: Artwork
    
    @Injected(\.artworkService) private var service
    
    init(artwork: Artwork) {
        self.artwork = artwork
    }
    
    func send(action: Action) {
        switch action {
        case .loadArtistInfo:
            requestArtistInfo()
        }
    }
    
    private func requestArtistInfo() {
        state = .loadingArtistInfo
        
        Task {
            guard let id = artwork.artistId else {
                await MainActor.run { state = .artistInfoEmpty }
                return
            }
            
            do {
                let artist = try await service.getArtistData(id)
                await MainActor.run { state = .loaded(artist) }
            } catch {
                await MainActor.run { state = .errorLoadingArtistInfo }
            }
        }
    }
}
