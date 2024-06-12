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
        case login
    }
    
    @Published private(set) var state = LoginState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .writeEmail(let text):
            writeEmail(text)
        case .writePassword(let text):
            writePassword(text)
        case .login:
            login()
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

extension LoginIntent {
    private func login() {
        UserManager.login(
            email: state.emailInputText,
            password: state.passwordInputText
        )
        .sink { [weak self] completion in
            guard let 
                    self else { return }
            
            if case .failure(let error) = completion {
                print("errors", error)
                state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            }
            state.isLoading = false
        } receiveValue: { [weak self] userInfo in
            guard let self else { return }
            
            print(userInfo)
        }
        .store(in: &cancelable)
    }
}
