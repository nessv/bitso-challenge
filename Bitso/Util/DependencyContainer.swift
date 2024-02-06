//
//  DependencyContainer.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Factory

extension Container {
    var artworkService: Factory<ArtworkService> {
        Factory(self) { ArtworkServiceImpl() }
    }
}
