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
    enum State { case initial, loadingArtistInfo, loaded(_ artist: Artist), errorLoadingArtistInfo, artistInfoEmpty }
    
    @Published var state: State = .initial
    @Published var artwork: Artwork.Data
    
    @Injected(\.artworkService) private var service
    
    init(artwork: Artwork.Data) {
        self.artwork = artwork
    }
    
    func send(action: Action) {
        switch action {
        case .loadArtistInfo:
            requestArtistInfo()
        }
    }
    
    private func requestArtistInfo() {
        Task {
            guard let id = artwork.artistId else {
                await MainActor.run { state = .artistInfoEmpty }
                return
            }
            
            do {
                let artist = try await service.getArtistData(id)
                
                await MainActor.run {
                    state = .loaded(artist)
                }
            } catch {
                await MainActor.run {
                    state = .errorLoadingArtistInfo
                }
            }
        }
    }
}
