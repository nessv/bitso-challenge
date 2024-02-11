//
//  Entry.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/11/24.
//

import Foundation

extension Cache {
    final class Entry: NSObject {
        let key: Key
        let value: Value
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}
