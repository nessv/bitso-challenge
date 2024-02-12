//
//  CacheTests.swift
//  BitsoTests
//
//  Created by Néstor Valdez on 2/10/24.
//

import XCTest
@testable import Bitso

final class CacheTests: XCTestCase {

    func testSingleCacheArtist() {
        let artistCacheTest = Cache<Int, Artist>()
        // Mock artist model
        let artistId = 1
        let artist = Artist(data: .init(id: artistId, title: "John Doe"))
        // Store in cache
        artistCacheTest[artistId] = artist
        // Retrieve back from cache
        guard let cachedArtist = artistCacheTest[artistId] else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(cachedArtist.data.id == artistId)
    }
    
    func testMultipleCacheArtist() {
        let artistCacheTest = Cache<Int, Artist>()
        // Mock artist model
        let artistId1 = 1
        let artistId2 = 2
        let artistId3 = 3
        
        let artist1 = Artist(data: .init(id: artistId1, title: "John One"))
        let artist2 = Artist(data: .init(id: artistId2, title: "John Two"))
        let artist3 = Artist(data: .init(id: artistId3, title: "John Three"))
        
        // Store in cache
        artistCacheTest[artistId1] = artist1
        artistCacheTest[artistId2] = artist2
        artistCacheTest[artistId3] = artist3
        
        // Retrieve back from cache
        [artistId1, artistId2, artistId3].forEach {
            guard let cachedArtist = artistCacheTest[$0] else {
                XCTFail()
                return
            }
            
            XCTAssertTrue(cachedArtist.data.id == $0)
        }
    }
    
    func testSaveToDisk() {
        // Create a new instance of cache
        let cache = Cache<Int, String>()
        // Store values in cache
        cache[1] = "One"
        cache[2] = "Two"
        // Save cache to Disk
        do {
            try cache.saveToDisk(withName: .test)
        } catch {
            // If it's not possible to save to disk, fail the test
            XCTFail()
        }
        
        // Create a new instance of cache, but first check if there's cache saved in disk
        let newCache = Cache<Int, String>.retrieveFromDiskIfPossible(.test)
        // Check if cache has the previously stored values
        guard let cache1 = newCache[1], let cache2 = newCache[2] else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(cache1 == "One")
        XCTAssertTrue(cache2 == "Two")
    }
    
    func testClearCache() {
        // Create a new instance of Cache
        let cache = Cache<Int, String>()
        // Store some values in our cache
        cache[1] = "One"
        cache[2] = "Two"
        // Validate that both values are in the cache
        if cache[1] == nil || cache[2] == nil { XCTFail() }
        // Remove both values from our cache
        cache.removeValue(forKey: 1)
        cache.removeValue(forKey: 2)
        
        XCTAssertTrue(cache[1] == nil && cache[2] == nil)
        
    }
}
