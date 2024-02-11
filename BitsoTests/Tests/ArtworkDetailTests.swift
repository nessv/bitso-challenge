//
//  ArtworkDetailTests.swift
//  BitsoTests
//
//  Created by Néstor Valdez on 2/11/24.
//

import XCTest
import Factory

@testable import Bitso

final class ArtworkDetailTests: XCTestCase {
    private var viewModel: ArtworkDetailViewModel!
    
    override func setUp() {
        super.setUp()
        
        Container.shared.reset()
        Container.shared.artworkService.register { MockService() }
    }
    
    func testLoadingArtistInfo() async {
        // Grab a mock Artwork
        let artwork = Artwork(id: 1234, title: "Test", artistId: 35363)
        // Initialize the vm with the mock artwork
        viewModel = ArtworkDetailViewModel(artwork: artwork)
        
        XCTAssertEqual(viewModel.state, .initial)
        
        let expectation = XCTestExpectation(description: "Trigger load artist info and receive an artist")
        viewModel.send(action: .loadArtistInfo)
        
        XCTAssertEqual(viewModel.state, .loadingArtistInfo)
        
        waitForUpdate { expectation.fulfill() }
        await fulfillment(of: [expectation])
        
        if case .loaded(_) = viewModel.state {
            XCTAssert(true)
        } else {
            XCTFail("\(viewModel.state) is not the correct state after fetching a valid artist")
        }
    }
    
    func testLoadingArtistInfoFail() async {
        // Grab a mock Artwork with an invalid artistId
        let artwork = Artwork(id: 1234, title: "Test", artistId: 1234)
        // Initialize the vm with the mock artwork
        viewModel = ArtworkDetailViewModel(artwork: artwork)
        
        // We skip everything we check in `testLoadingArtistInfo`
        let expectation = XCTestExpectation(description: "Trigger load artist info and receive an error")
        viewModel.send(action: .loadArtistInfo)
        
        waitForUpdate { expectation.fulfill() }
        await fulfillment(of: [expectation])
        
        XCTAssertEqual(viewModel.state, .errorLoadingArtistInfo)
    }
    
    func testLoadingArtistInfoEmpty() async {
        // Grab a mock Artwork with a nil artist id
        let artwork = Artwork(id: 1234, title: "Test", artistId: nil)
        // Initialize the vm with the mock artwork
        viewModel = ArtworkDetailViewModel(artwork: artwork)
        
        // We skip everything we check in `testLoadingArtistInfo`
        let expectation = XCTestExpectation(description: "Trigger load artist info and receive an empty artist")
        viewModel.send(action: .loadArtistInfo)
        
        waitForUpdate { expectation.fulfill() }
        await fulfillment(of: [expectation])
        
        XCTAssertEqual(viewModel.state, .artistInfoEmpty)
    }
}
