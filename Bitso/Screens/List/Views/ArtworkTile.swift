//
//  ArtworkTile.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/7/24.
//

import SwiftUI

struct ArtworkTile: View {
    var art: Artwork
    
    var body: some View {
        HStack(alignment: .center) {
            CustomImageView(resourceId: art.imageId)
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(art.title)
                    .lineLimit(2)
                    .font(.custom(FuturaRound.bold.font, size: FontStyle.headline.size))
                    .multilineTextAlignment(.leading)
                
                Text(art.artistTitle ?? "unknown")
                    .font(.custom(FuturaRound.light.font, size: FontStyle.subheadline.size))
                    .lineLimit(1)
                
            }
            .foregroundStyle(Color.primary)
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 10))
        .background {
            Rectangle()
                .fill(.tileBackground)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 6)
        }
    }
}

#Preview {
    ArtworkTile(art: .init(id: 37281, title: "Chicago Stock Exchange Trading Room: Stencil",
                           thumbnail: nil,
                           artistTitle: "Adler & Sulivan, Architexts",
                           description: "The Chicago Stock Exchange building was one of Dankmar Adler and Louis Sullivan’s most distinctive commercial projects. The centerpiece of this 13-story structure was the trading room—a dramatic, double-height space filled with Sullivan’s lush ornament and the multicolored, stenciled wall covering seen here. After an unsuccessful preservation battle in the late 1960s, the building was demolished, but the Art Institute was able to acquire the monumental entry arch, now located in a garden next to the Modern Wing.",
                           imageId: "d8ca9156-1ae6-a96d-d478-28cea07a1964", artistId: 40566))
}
