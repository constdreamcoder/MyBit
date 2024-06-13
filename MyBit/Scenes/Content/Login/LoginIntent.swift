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
    @KeychainStorage(key: .accessToken) private var accessToken: String?
    @KeychainStorage(key: .refreshToken) private var refreshToken: String?
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .writeEmail(let text):
            writeEmail(text)
        case .writePassword(let text):
            writePassword(text)
        case .login:
            login() // TODO: - 과도한 네트워크 요청 방지를 위한 debounce 추가하기
        }
    }
}

extension LoginIntent {
    private func writeEmail(_ text: String) {
        print("email:", text)
        state.emailInputText = text
        state.emailValidation = isValidEmail(text)
        isValidSignUp()
    }
    
    private func writePassword(_ text: String) {
        print("Password:", text)
        state.passwordInputText = text
        state.passwordValidation = isValidPassword(text)
        isValidSignUp()
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
            
            accessToken = userInfo.token.accessToken
            refreshToken = userInfo.token.refreshToken
            state.userInfo = userInfo
        }
        .store(in: &cancelable)
    }
}

extension LoginIntent {
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // 최소 8자 이상
        let lengthPredicate = NSPredicate(format: "SELF MATCHES %@", ".{8,}")
        
        // 하나 이상의 대문자
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        
        // 하나 이상의 소문자
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        
        // 하나 이상의 숫자
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        
        // 하나 이상의 특수 문자
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*(),.?\":{}|<>]+.*")
        
        // 모든 조건을 만족하는지 확인
        return lengthPredicate.evaluate(with: password) &&
        uppercasePredicate.evaluate(with: password) &&
        lowercasePredicate.evaluate(with: password) &&
        numberPredicate.evaluate(with: password) &&
        specialCharacterPredicate.evaluate(with: password)
    }
    
    private func isValidSignUp() {
        print("----------------------유효성 검사-------------------------")
        print("emailValidation", state.emailValidation)
        print("passwordValidation", state.passwordValidation)
        
        state.loginValidation = state.emailValidation && state.passwordValidation
        print("signUpValidation", state.loginValidation)
        print("----------------------------------------------------------")
        
    }
}
