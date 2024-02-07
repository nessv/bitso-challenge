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
            AsyncImage(url: URL(string: "https://www.artic.edu/iiif/2/\(art.image_id ?? "")/full/843,/0/default.jpg")) { image in
                image.resizable()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 150, height: 150)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(art.title)
                    .lineLimit(3)
                    .font(.headline)
                
                Text(art.artist_title ?? "unknown")
                    .font(.caption)
                
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 10))
        .background {
            Rectangle()
                .fill(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 6)
        }
    }
}
