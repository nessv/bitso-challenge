//
//  BitsoTests.swift
//  BitsoTests
//
//  Created by Néstor Valdez on 2/6/24.
//

import XCTest
@testable import Bitso

final class FormatingTests: XCTestCase {
    // MARK: String Extension Test
    func testStripHTMLFromString() {
        
        let stringsWithHTML = [
            "This is a <b>bold</b> statement.",
            "<p>Hello, <em>world</em>!</p>",
            "Click <a href=\"https://example.com\">here</a> for more information.",
            "<h1>Welcome to our website!</h1>",
        ]
        
        let resultStrings = [
            "This is a bold statement.",
            "Hello, world!",
            "Click here for more information.",
            "Welcome to our website!"
        ]
        
        stringsWithHTML.enumerated().forEach { index, item in
            XCTAssertEqual(item.stripHTML, resultStrings[index])
        }
    }
    
    func testArtistDate() {
        let artist1 = Artist(data: .init(id: 123, title: "John Doe", birthDate: 1832, deathDate: 1900))
        XCTAssertEqual(artist1.data.date, "1832 - 1900")
        
        let artist2 = Artist(data: .init(id: 123, title: "John Doe", birthDate: 1832, deathDate: nil))
        XCTAssertEqual(artist2.data.date, "1832 - ")
        
        let artist3 = Artist(data: .init(id: 123, title: "John Doe", birthDate: nil, deathDate: 1900))
        XCTAssertEqual(artist3.data.date, " - 1900")
    }
}
