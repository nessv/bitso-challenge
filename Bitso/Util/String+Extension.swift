//
//  String+Extension.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/6/24.
//

import Foundation

extension String {
    var stripHTML: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
