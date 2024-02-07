//
//  ArtworkListViewModel.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation
import Factory

final class ArtworkListViewModel: ViewModel {
    @Injected(\.artworkService) private var service
    
    enum Action { case loadMoreArtwork, refresh }
    enum State { case initial, loading, loaded, error }
    
    private var currentPage = 1
    
    // MARK: Public
    @Published var artwork: Artwork = Artwork()
    @Published var state: State = .initial
    
    func send(action: Action) {
        switch action {
        case .loadMoreArtwork:
            getArtwork()
        case .refresh:
            break
        }
    }
    
    // MARK: Private functions
    private func getArtwork() {
        Task {
            await MainActor.run { state = .loading }
            
            let artworkData = try await service.getArtworksByPage(currentPage)
            
            await MainActor.run {
                artwork = artworkData
                state = .loaded
            }
        }
    }
}
