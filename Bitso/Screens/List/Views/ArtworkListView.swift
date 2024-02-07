//
//  ArtworkListView.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import SwiftUI

struct ArtworkListView: View {
    @StateObject var viewModel = ArtworkListViewModel()
    
    static var tileSize: CGFloat { UIScreen.main.bounds.width / 2 }
    
    private let adaptiveColumn = [
        GridItem(.flexible(maximum: tileSize)),
        GridItem(.flexible(maximum: tileSize))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .initial: VStack {}.onAppear { viewModel.send(action: .loadMoreArtwork) }
                case .loading: ProgressView()
                case .loaded: loadedView
                case .error: EmptyView()
                }
            }
            .navigationTitle("Artwork")
        }
    }
    
    private var loadedView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.artwork.data, id: \.id) { ArtworkTile(art: $0) }
            }
            .padding(16)
        }
        .refreshable {}
    }
}

#Preview {
    ArtworkListView()
}
