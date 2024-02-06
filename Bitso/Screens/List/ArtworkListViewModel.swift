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
    
    enum Action {
        case loadMoreArtwork
        case refresh
    }
    
    enum State {
        case initial
        case loading
        case loaded
        case error
    }
    
    // MARK: Public
    @Published var artwork: ArtworkData = ArtworkData()
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
            let artworkData = try await service.getArtworksByPage(0)
            
            await MainActor.run {
                artwork = artworkData
            }
        }
    }
}

protocol ViewModel: ObservableObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    func send(action: Action)
}
