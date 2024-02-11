//
//  KeyTracker.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/11/24.
//

import Foundation

extension Cache {
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
            guard let entry = obj as? Entry else { return }
            
            keys.remove(entry.key)
        }
    }
}
