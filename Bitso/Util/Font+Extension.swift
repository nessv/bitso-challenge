//
//  Font+Extension.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/7/24.
//

import Foundation
import SwiftUI

typealias FontStyle = UIFont.TextStyle

enum FuturaRound {
    case light, medium, bold
    
    var font: String {
        switch self {
        case .light: return "FuturaRound-Light"
        case .medium: return "FuturaRound-Medium"
        case .bold: return "FuturaRound-Bold"
        }
    }
}

extension UIFont.TextStyle {
    var size: CGFloat { UIFont.preferredFont(forTextStyle: self).pointSize }
}
