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
        case write(inputKind: InputKind)
        case login
    }
    
    @Published private(set) var state = LoginState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .write(let inputKind):
            write(inputKind)
        case .login:
            login() // TODO: - 과도한 네트워크 요청 방지를 위한 debounce 추가하기
        }
    }
}

extension LoginIntent {
    
    private func write(_ inputKind: InputKind) {
        switch inputKind {
        case .email(let input):
            writeEmail(input, inputKind: inputKind)
        case .password(let input):
            writePassword(input, inputKind: inputKind)
        default: break
        }
        
        isValidSignUp()
    }
    
    private func writeEmail(_ text: String, inputKind: InputKind) {
        print("email:", text)
        state.emailInputText = text
        state.emailValidation = inputKind.isValid
    }
    
    private func writePassword(_ text: String, inputKind: InputKind) {
        print("Password:", text)
        state.passwordInputText = text
        state.passwordValidation = inputKind.isValid
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
            
            KeychainManager.create(key: .accessToken, value: userInfo.token.accessToken)
            KeychainManager.create(key: .refreshToken, value: userInfo.token.refreshToken)
          
            state.userInfo = userInfo
        }
        .store(in: &cancelable)
    }
}

extension LoginIntent {
    private func isValidSignUp() {
        print("----------------------유효성 검사-------------------------")
        print("emailValidation", state.emailValidation)
        print("passwordValidation", state.passwordValidation)
        
        state.loginValidation = state.emailValidation && state.passwordValidation
        print("signUpValidation", state.loginValidation)
        print("----------------------------------------------------------")
        
    }
}
