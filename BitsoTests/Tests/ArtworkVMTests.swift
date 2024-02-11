//
//  ArtworkVMTests.swift
//  BitsoTests
//
//  Created by Néstor Valdez on 2/10/24.
//

import XCTest
import Factory

@testable import Bitso

@MainActor final class ArtworkVMTests: XCTestCase {
    private var viewModel: ArtworkListViewModel!
    
    override func setUp() {
        super.setUp()
        
        Container.shared.reset()
        Container.shared.artworkService.register { MockService() }
        
        viewModel = ArtworkListViewModel()
    }
    
    func testStateChange() async {
        // Initial state should be `initial`
        XCTAssertTrue(viewModel.state == .initial)
        // Start loading artwork for the first time
        let expectation = XCTestExpectation(description: "Should change state after loading artwork")
        viewModel.send(action: .loadMoreArtwork(.zero))
        // Wait until artwork completes fetching
        waitForUpdate { expectation.fulfill() }
        await fulfillment(of: [expectation], timeout: 10)
        // State should now be `loaded`
        XCTAssertEqual(viewModel.state, .loaded)
        // the current page should now be set to 1
        XCTAssertEqual(viewModel.currentPage.currentPage, 1)
    }
    
    func testLoadingMorePages() async {
        await testStateChange()
        // We load more artwork
        let lastIdInTheFirstPage = 27009
        let expectation = XCTestExpectation(description: "State should change from `loaded` to `loading` and back to `loaded. Current page should be 2 and artwork count 24")
        viewModel.send(action: .loadMoreArtwork(lastIdInTheFirstPage))
        
        waitForUpdate { expectation.fulfill() }
        await fulfillment(of: [expectation], timeout: 10)
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.currentPage.currentPage, 2)
        XCTAssertEqual(viewModel.artwork.data.count, 24)
    }
    
    func testRefreshArtwork() async {
        await testStateChange()
        
        viewModel.send(action: .refresh)
        // Everything should be set back to initial parameters
        XCTAssertEqual(viewModel.artwork.data.count, .zero)
        XCTAssertEqual(viewModel.state, .initial)
        XCTAssertTrue(viewModel.currentPage.currentPage == .zero)
        
        let expectation = XCTestExpectation(description: "Data should be fetch back after setting everything back to initial parameters")
        
        waitForUpdate { expectation.fulfill() }
        await fulfillment(of: [expectation])
        // State should now be `loaded`
        XCTAssertEqual(viewModel.state, .loaded)
        // the current page should now be set to 1
        XCTAssertEqual(viewModel.currentPage.currentPage, 1)
    }
}
