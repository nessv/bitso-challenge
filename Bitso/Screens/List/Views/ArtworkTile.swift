//
//  ArtworkTile.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/7/24.
//

import SwiftUI

struct ArtworkTile: View {
    var art: Artwork.Data
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: "https://www.artic.edu/iiif/2/\(art.image_id ?? "")/full/843,/0/default.jpg")) { image in
                image.resizable()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(art.title)
                    .lineLimit(2)
                    .font(.custom(FuturaRound.bold.font, size: FontStyle.headline.size))
                
                Text(art.artist_title ?? "unknown")
                    .font(.custom(FuturaRound.light.font, size: FontStyle.subheadline.size))
                
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 10))
        .background {
            Rectangle()
                .fill(.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 6)
        }
    }
}
