//
//  Cache.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/9/24.
//

import Foundation

enum CachedContent: String {
    case artist
    case artwork
}

final class Cache<Key: Hashable, Value: Decodable> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let keyTracker = KeyTracker()
    
    init() {
        wrapped.delegate = keyTracker
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

extension Cache {
    subscript(key: Key) -> Value? {
        get { return entry(forKey: key)?.value }
        set {
            guard let newValue else {
                removeValue(forKey: key)
                return
            }
            
            insert(.init(key: key, value: newValue))
        }
    }
}

extension Cache: Codable where Key: Codable, Value: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(insert)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
}

extension Cache {
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

private extension Cache {
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

private extension Cache {
    func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else { return nil }
        return entry
    }
    
    func insert(_ entry: Entry) {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
}

private extension Cache {
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
            guard let entry = obj as? Entry else { return }
            
            keys.remove(entry.key)
        }
    }
}

extension Cache where Key: Codable, Value: Codable {
    func saveToDisk(withName name: CachedContent, using fileManager: FileManager = .default) throws {
        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        
        let fileURL = folderURLs[0].appendingPathComponent(name.rawValue + ".cache")
        let data = try JSONEncoder().encode(self)
        do {
            try data.write(to: fileURL)
        } catch let error { debugPrint(error.localizedDescription) }
    }
    
    static func retrieveFromDiskIfPossible(_ name: CachedContent) -> Cache {
        let folderURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        
        do {
            let object = try Data(contentsOf: folderURLs[0].appendingPathComponent(name.rawValue + ".cache"))
            return try JSONDecoder().decode(Cache.self, from: object)
        } catch {}
        
        return Cache()
    }
}