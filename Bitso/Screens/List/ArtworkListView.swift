//
//  ArtworkListView.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import SwiftUI

struct ArtworkListView: View {
    @StateObject var viewModel: ArtworkListViewModel
    
    init(viewModel: ArtworkListViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        // Necessary to apply the same font style to the navigation bar title
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: FuturaRound.bold.font, size: FontStyle.largeTitle.size) as Any]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: FuturaRound.medium.font, size: FontStyle.title3.size) as Any]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .initial: ProgressView().onAppear { viewModel.send(action: .loadMoreArtwork(.zero)) }
                case .loaded, .loading: loadedView
                case .error: EmptyView()
                }
            }
            .navigationTitle("Artwork")
        }
    }
    
    private var loadedView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.artwork.data, id: \.id) { art in
                    NavigationLink(destination: ArtworkDetailView(artwork: art)) {
                        ArtworkTile(art: art)
                            .onAppear { viewModel.send(action: .loadMoreArtwork(art.id)) }
                    }
                }
                
                if case .loading = viewModel.state {
                    ProgressView()
                }
            }
            .padding(16)
        }
        .refreshable { viewModel.send(action: .refresh) }
    }
}

#Preview {
    ArtworkListView()
}
