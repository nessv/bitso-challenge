//
//  ArtworkDetailView.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/8/24.
//

import SwiftUI

struct ArtworkDetailView: View {
    @StateObject private var viewModel: ArtworkDetailViewModel
    
    init(artwork: Artwork) {
        _viewModel = StateObject(wrappedValue: ArtworkDetailViewModel(artwork: artwork))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                CustomImageView(resourceId: viewModel.artwork.imageId)
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 16))
                
                if let description = viewModel.artwork.description {
                    Text(description.stripHTML)
                        .font(.custom(FuturaRound.medium.font, size: FontStyle.body.size))
                        .foregroundStyle(.gray)
                }
                
                artistInfo
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("Artwork & Artist")
        .onAppear { viewModel.send(action: .loadArtistInfo) }
    }
    
    @ViewBuilder
    private var artistInfo: some View {
        switch viewModel.state {
        case .initial:
            ProgressView()
        case .loadingArtistInfo:
            ProgressView()
        case .loaded(let artist):
            VStack(alignment: .leading, spacing: 8) {
                Text("Artist Information")
                    .font(.custom(FuturaRound.medium.font, size: FontStyle.title1.size))
                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text(artist.data.title)
                            .font(.custom(FuturaRound.bold.font,
                                          size: FontStyle.headline.size))
                    }
                }
                if let description = artist.data.description {
                    Text(description.stripHTML)
                        .font(.custom(FuturaRound.medium.font, size: FontStyle.body.size))
                        .foregroundStyle(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        case .errorLoadingArtistInfo: artistErrorView
        case .artistInfoEmpty: artistInfoEmpty
        }
    }
    
    private var artistErrorView: some View {
        VStack {
            Text("There was an error getting the artist information")
                .foregroundStyle(.red)
            Button("Tap to try again") {
                viewModel.send(action: .loadArtistInfo)
            }
        }
        .font(.custom(FuturaRound.medium.font, size: FontStyle.body.size))
    }
    
    private var artistInfoEmpty: some View {
        VStack {
            Text("There's no artist information available")
                .foregroundStyle(.primary)
        }
        .font(.custom(FuturaRound.medium.font, size: FontStyle.body.size))
    }
}

#Preview {
    ArtworkDetailView(artwork: .init(id: 37281, title: "Chicago Stock Exchange Trading Room: Stencil",
                                     thumbnail: nil,
                                     artistTitle: "Adler & Sulivan, Architexts",
                                     description: "The Chicago Stock Exchange building was one of Dankmar Adler and Louis Sullivan’s most distinctive commercial projects. The centerpiece of this 13-story structure was the trading room—a dramatic, double-height space filled with Sullivan’s lush ornament and the multicolored, stenciled wall covering seen here. After an unsuccessful preservation battle in the late 1960s, the building was demolished, but the Art Institute was able to acquire the monumental entry arch, now located in a garden next to the Modern Wing.",
                                     imageId: "d8ca9156-1ae6-a96d-d478-28cea07a1964", artistId: 40566))
}
