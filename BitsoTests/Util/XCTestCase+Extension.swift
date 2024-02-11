//
//  XCTestCase+Extension.swift
//  BitsoTests
//
//  Created by Néstor Valdez on 2/11/24.
//

import XCTest

extension XCTestCase {
    func waitForUpdate(_ time: TimeInterval = 1, _ closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { closure() }
    }
}
