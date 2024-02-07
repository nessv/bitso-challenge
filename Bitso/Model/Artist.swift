//
//  Artist.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/7/24.
//

import Foundation

struct Artist: Codable {
    var data: Artist.Data
    
    struct Data: Codable {
        var id: Int
        var title: String
        var description: String?
    }
}
