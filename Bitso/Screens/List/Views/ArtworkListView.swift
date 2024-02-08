//
//  ArtworkListView.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import SwiftUI

struct ArtworkListView: View {
    @StateObject var viewModel = ArtworkListViewModel()
    
    init() {
        // Necessary to apply the same font style to the navigation bar title
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: FuturaRound.bold.font, size: FontStyle.largeTitle.size) as Any]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: FuturaRound.medium.font, size: FontStyle.title3.size) as Any]
    }
    
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
                ForEach(viewModel.artwork.data, id: \.id) { art in
                    NavigationLink(destination: ArtworkDetailView(artwork: art)) {
                        ArtworkTile(art: art)
                    }
                }
            }
            .padding(16)
        }
        .refreshable {}
    }
}

#Preview {
    ArtworkListView()
}
