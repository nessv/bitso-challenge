//
//  Entry.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/11/24.
//

import Foundation

extension Cache {
    // Since NSCache requires the use of Class Objects,
    // our Entry needs to be a Class
    final class Entry {
        let key: Key
        let value: Value
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}
