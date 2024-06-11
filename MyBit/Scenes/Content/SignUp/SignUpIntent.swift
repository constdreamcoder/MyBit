//
//  SignUpIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import Foundation
import Combine

final class SignUpIntent: IntentType {
    
    enum Action {
        case writeEmail(text: String)
        case writeNickname(text: String)
        case writePhoneNumber(text: String)
        case writePassword(text: String)
        case writePasswordConfirm(text: String)
    }
    
    @Published private(set) var state = SignUpState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .writeEmail(let text):
            writeEmail(text)
        case .writeNickname(let text):
            writeNickname(text)
        case .writePhoneNumber(let text):
            writePhoneNumber(text)
        case .writePassword(let text):
            writePassword(text)
        case .writePasswordConfirm(let text):
            writePasswordConfirm(text)
        }
    }
}

extension SignUpIntent {
    private func writeEmail(_ text: String) {
        state.emailInputText = text
        print("email:", text)
    }
    
    private func writeNickname(_ text: String) {
        state.nicknameInputText = text
        print("Nickname:", text)
    }
    
    private func writePhoneNumber(_ text: String) {
        state.phoneNumberInputText = text
        print("PhoneNumber:", text)
    }
    
    private func writePassword(_ text: String) {
        state.passwordInputText = text
        print("Password:", text)
    }
    
    private func writePasswordConfirm(_ text: String) {
        state.passwordConfirmInputText = text
        print("PasswordConfirm:", text)
    }
}
