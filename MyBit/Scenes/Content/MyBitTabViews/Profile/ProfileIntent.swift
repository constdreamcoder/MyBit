//
//  ProfileIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import Foundation
import Combine

final class ProfileIntent: IntentType {
    enum Action {
        
    }
    
    @Published private(set) var state = ProfileState()
    
    var cancelable = Set<AnyCancellable>()
        
    func send(_ action: Action) {
        switch action {
            
        }
    }
}
