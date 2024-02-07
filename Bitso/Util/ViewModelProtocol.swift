//
//  ViewModelProtocol.swift
//  Bitso
//
//  Created by Néstor Valdez on 2/7/24.
//

import Foundation

protocol ViewModel: ObservableObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    func send(action: Action)
}
