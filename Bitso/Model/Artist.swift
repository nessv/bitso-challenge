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
        var birthDate: Int?
        var deathDate: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case description
            case birthDate = "birth_date"
            case deathDate = "death_date"
        }
    }
}

extension Artist.Data {
    var date: String {
        let birthD = birthDate == nil ? "" : String(birthDate!)
        let deathD = deathDate == nil ? "" : String(deathDate!)
        
        return birthD + " - " + deathD
    }
}
