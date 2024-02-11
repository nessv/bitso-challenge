//
//  SnapshotTests.swift
//  BitsoTests
//
//  Created by Néstor Valdez on 2/11/24.
//

import XCTest
import SnapshotTesting
import Factory

@testable import Bitso

@MainActor final class SnapshotTests: XCTestCase {
    private var artworkViewModel: ArtworkListViewModel!
    
    override func setUp() {
        super.setUp()
        
        Container.shared.reset()
        Container.shared.artworkService.register { MockService() }
        
        artworkViewModel = ArtworkListViewModel()
    }
    
    func testArtworkListView() async {
        let view = ArtworkListView(viewModel: artworkViewModel)
        // Assert Loading Image Snapshot
        assertSnapshot(of: view, as: .image, named: "artwork_list_loading", testName: "loading")
        // Load Content
        let expectation = XCTestExpectation(description: "Should change state after loading artwork")
        artworkViewModel.send(action: .loadMoreArtwork(.zero))
        // Wait until artwork completes fetching
        waitForUpdate { expectation.fulfill() }
        await fulfillment(of: [expectation])
        
        assertSnapshot(of: view, as: .image, named: "artwork_list_loaded", testName: "loaded")
    }
}
