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
        case write(inputKind: InputKind)
        case emailDoubleCheck
        case join
    }
    
    @Published private(set) var state = SignUpState()
    
    private var inputEmailDoubleCheck = PassthroughSubject<Void, Never>()
    
    var cancelable = Set<AnyCancellable>()
    
    init() {
        action()
    }
    
    func send(_ action: Action) {
        switch action {
        case .write(let inputKind):
            write(inputKind)
        case .emailDoubleCheck:
            inputEmailDoubleCheck.send(())
        case .join:
            join()
        }
    }
    
    private func action() {
        inputEmailDoubleCheck
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                emailDoubleCheck()
            }
            .store(in: &cancelable)
    }
}

extension SignUpIntent {
    private func emailDoubleCheck() {
        print("중복 확인:", state.emailInputText)
        state.isLoading = true
        state.errorMessage = nil
        
        UserManager.emailValidation(state.emailInputText)
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors", error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    state.emailValidation = false
                }
                state.isLoading = false
            } receiveValue: { [weak self] success in
                guard let self else { return }
                
                print(success)
                state.emailValidation = success
                isValidSignUp()
            }
            .store(in: &cancelable)
    }
    
    private func join() {
        UserManager.join(
            email: state.emailInputText,
            password: state.passwordInputText,
            nickname: state.nicknameInputText,
            phone: InputKind.isValidFormattedPhoneNumber(state.phoneNumberInputText) ? state.phoneNumberInputText : nil
        )
        .sink { [weak self] completion in
            guard let self else { return }
            
            if case .failure(let error) = completion {
                print("errors", error)
                state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            }
            state.isLoading = false
        } receiveValue: { [weak self] userInfo in
            guard let self else { return }
            
            print(userInfo)
            
//            KeychainManager.create(key: .profileImage, value: userInfo.profileImage ?? "")
            KeychainManager.create(key: .accessToken, value: userInfo.token.accessToken)
            KeychainManager.create(key: .refreshToken, value: userInfo.token.refreshToken)
            
            state.userInfo = userInfo
        }
        .store(in: &cancelable)
    }
}


extension SignUpIntent {
    
    private func write(_ inputKind: InputKind) {
        switch inputKind {
        case .email(let input):
            writeEmail(input, inputKind: inputKind)
        case .nickname(let input):
            writeNickname(input, inputKind: inputKind)
        case .phone(let input):
            writePhoneNumber(input, inputKind: inputKind)
        case .password(let input):
            writePassword(input, inputKind: inputKind)
        case .passwordConfirm(let input, _):
            writePasswordConfirm(input, inputKind: inputKind)
        }
        
        isValidSignUp()
    }
    
    private func writeEmail(_ text: String, inputKind: InputKind) {
        print("email:", text)
        state.emailInputText = text
        state.emailDoubleCheckButtonValidation = inputKind.isValid
    }
    
    private func writeNickname(_ text: String, inputKind: InputKind) {
        print("Nickname:", text)
        state.nicknameInputText = text
        state.nicknameValidation = inputKind.isValid
    }
    
    private func writePhoneNumber(_ text: String, inputKind: InputKind) {
        print("PhoneNumber:", text)
        
        state.phoneNumberInputText = inputKind.formatPhoneNumber
    }
    
    private func writePassword(_ text: String, inputKind: InputKind) {
        print("Password:", text)
        state.passwordInputText = text
        state.passwordValidation = inputKind.isValid
    }
    
    private func writePasswordConfirm(_ text: String, inputKind: InputKind) {
        print("PasswordConfirm:", text)
        state.passwordConfirmInputText = text
        state.passwordConfirmValidation = inputKind.isValid
    }
}

extension SignUpIntent {
    
    private func isValidSignUp() {
        print("----------------------유효성 검사-------------------------")
        print("emailDoubleCheckButtonValidation", state.emailDoubleCheckButtonValidation)
        print("emailValidation", state.emailValidation)
        print("nicknameValidation", state.nicknameValidation)
        print("passwordValidation", state.passwordValidation)
        print("passwordConfirmValidation", state.passwordConfirmValidation)
        
        state.signUpValidation = state.emailDoubleCheckButtonValidation
        && state.emailValidation
        && state.nicknameValidation
        && state.passwordValidation
        && state.passwordConfirmValidation
        print("signUpValidation", state.signUpValidation)
        print("----------------------------------------------------------")
    }
}
