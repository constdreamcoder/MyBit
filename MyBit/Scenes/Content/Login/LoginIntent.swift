//
//  LoginIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/11/24.
//

import Foundation
import Combine

final class LoginIntent: IntentType {
    
    enum Action {
        case writeEmail(text: String)
        case writePassword(text: String)
    }
    
    @Published private(set) var state = LoginState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .writeEmail(let text):
            writeEmail(text)
        case .writePassword(let text):
            writePassword(text)
        }
    }
}

extension LoginIntent {
    private func writeEmail(_ text: String) {
        state.emailInputText = text
        print("email:", text)
    }
    
    private func writePassword(_ text: String) {
        state.passwordInputText = text
        print("Password:", text)
    }
}
