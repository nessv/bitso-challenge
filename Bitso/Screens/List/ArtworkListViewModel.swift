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
    
    enum Action { case loadMoreArtwork(_ id: Int), refresh }
    enum State { case initial, loading, loaded, error }
    
    // MARK: Infinite scrolling
    private(set) var currentPage: Pagination = .initial()
    
    // MARK: Public
    @Published var artwork: ArtworkResponse = ArtworkResponse(data: [])
    @Published var state: State = .initial
    
    func send(action: Action) {
        switch action {
        case .loadMoreArtwork(let id):
            loadMoreArtwork(id)
        case .refresh:
            refresh()
        }
    }
    
    // MARK: Private functions
    private func getArtwork() {
        Task {
            await MainActor.run {
                // If it's the first time data is loaded, then the state should be
                // `initial`, if not then we will use the `loading` state
                // to update the UI accordanly
                state = currentPage.currentPage == .zero ? .initial : .loading
            }
            
            let newArtworkData = try await service.getArtworksByPage(currentPage.nextPage)
            
            if let pagination = newArtworkData.pagination {
                currentPage = pagination
            }
            
            await MainActor.run {
                // Append artwork to current data
                artwork.data.append(contentsOf: newArtworkData.data)
                state = .loaded
            }
        }
    }
    
    private func loadMoreArtwork(_ itemId: Int) {
        // If it's the first load, then retrieve the artwork without checking anything else
        if currentPage.currentPage == .zero {
            getArtwork()
            return
        }
        // Check if it's close to the end of the list
        guard itemId == artwork.data.last?.id else { return }
        getArtwork()
    }
    
    private func refresh() {
        // Remove all current artwork
        artwork.data.removeAll()
        // Set pagination back no initial value
        currentPage = .initial()
        // Set state back to initial
        state = .initial
        // Trigger artwork fetch
        getArtwork()
    }
}
