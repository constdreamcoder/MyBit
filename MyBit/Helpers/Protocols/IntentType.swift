//
//  IntentType.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/11/24.
//

import SwiftUI
import Combine

protocol IntentType: ObservableObject {
    associatedtype State: StateType
    associatedtype Action
    
    var state: State { get }
    
    func send(_ action: Action)
}
