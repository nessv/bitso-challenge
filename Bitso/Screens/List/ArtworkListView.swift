//
//  ArtworkListView.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import SwiftUI

struct ArtworkListView: View {
    @StateObject var viewModel = ArtworkListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.artwork.data, id: \.id) { ArtworkTile(art: $0) }
            }
            .padding()
        }
        .onAppear { viewModel.send(action: .loadMoreArtwork) }
    }
}

struct ArtworkTile: View {
    var art: Artwork
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading, spacing: 8) {
                Text(art.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(art.artist_title)
                    .foregroundStyle(Color.accentColor)
                    .font(.subheadline)
                Text(art.description?.stripHTML ?? "")
                    .lineLimit(3)
                    .font(.caption)
            }
            .padding(8)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 10))
        .background {
            Rectangle()
                .fill(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: .gray, radius: 2)
        }
    }
}

#Preview {
    ArtworkListView()
}
