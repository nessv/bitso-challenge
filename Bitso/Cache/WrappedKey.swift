//
//  WrappedKey.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/11/24.
//

import Foundation

extension Cache {
    // Since NSCache is only compatible with keys that
    // are subclasses of NSObject, this wrapper allows us
    // to use any Hashable key
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            
            return value.key == key
        }
    }
}
