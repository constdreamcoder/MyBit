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
        case emailDoubleCheck
    }
    
    @Published private(set) var state = SignUpState()
    
    private var inputemailDoubleCheck = PassthroughSubject<Void, Never>()
    
    var cancelable = Set<AnyCancellable>()
    
    init() {
        action()
    }
    
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
        case .emailDoubleCheck:
            inputemailDoubleCheck.send(())
        }
    }
    
    private func action() {
        inputemailDoubleCheck
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                emailDoubleCheck()
            }
            .store(in: &cancelable)
    }
}

extension SignUpIntent {
    private func writeEmail(_ text: String) {
        print("email:", text)
        state.emailInputText = text
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        state.emailDoubleCheckValidation = isValidEmail(trimmedText)
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
                }
                state.isLoading = false
            } receiveValue: { [weak self] success in
                guard let self else { return }
                
                print(success)
            }
            .store(in: &cancelable)
    }
}

extension SignUpIntent {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

