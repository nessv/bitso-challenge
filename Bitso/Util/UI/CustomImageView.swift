//
//  CustomImageView.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/10/24.
//

import SwiftUI
import NukeUI

struct CustomImageView: View {
    var resourceId: String?
    
    var body: some View {
        LazyImage(url: URL(string: ArtworkApi.image(resourceId ?? "").url)) { state in
            if let image = state.image {
                image.resizable()
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    if state.error != nil {
                        Text("Error Loading Image")
                            .lineLimit(2)
                            .font(.custom(FuturaRound.medium.font, size: 14))
                            .foregroundStyle(.red)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .animation(.default)
    }
}

#Preview {
    CustomImageView(resourceId: "d8ca9156-1ae6-a96d-d478-28cea07a1964")
        .frame(width: 200, height: 200)
}
