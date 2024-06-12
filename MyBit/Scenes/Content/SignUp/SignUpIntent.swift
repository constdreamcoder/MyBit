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
    
    private var inputEmailDoubleCheck = PassthroughSubject<Void, Never>()
    
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
            inputEmailDoubleCheck.send(())
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
    
    private func writeEmail(_ text: String) {
        print("email:", text)
        state.emailInputText = text
        state.emailDoubleCheckButtonValidation = isValidEmail(text)
        isValidSignUp()
    }
    
    private func writeNickname(_ text: String) {
        print("Nickname:", text)
        state.nicknameInputText = text
        state.nicknameValidation = isValidNickname(text)
        isValidSignUp()
    }
    
    private func writePhoneNumber(_ text: String) {
        print("PhoneNumber:", text)
        
        if isValidPhoneNumber(text) {
            state.phoneNubmerValidation = isValidPhoneNumber(text)
            state.phoneNumberInputText = text
        }
        isValidSignUp()
    }
    
    private func writePassword(_ text: String) {
        print("Password:", text)
        state.passwordInputText = text
        state.passwordValidation = isValidPassword(text)
        isValidSignUp()
    }
    
    private func writePasswordConfirm(_ text: String) {
        print("PasswordConfirm:", text)
        state.passwordConfirmInputText = text
        state.passwordConfirmValidation = isValidPasswordConfirm(text)
        isValidSignUp()
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
    
    private func isValidSignUp() {
        print("----------------------유효성 검사-------------------------")
        print("emailDoubleCheckButtonValidation", state.emailDoubleCheckButtonValidation)
        print("emailValidation", state.emailValidation)
        print("nicknameValidation", state.nicknameValidation)
        print("phoneNubmerValidation", state.phoneNubmerValidation)
        print("passwordValidation", state.passwordValidation)
        print("passwordConfirmValidation", state.passwordConfirmValidation)
        
        
        state.signUpValidation = state.emailDoubleCheckButtonValidation
                                && state.emailValidation
                                && state.nicknameValidation
                                && state.phoneNubmerValidation
                                && state.passwordValidation
                                && state.passwordConfirmValidation
        print("signUpValidation", state.signUpValidation)
        print("----------------------------------------------------------")

    }
}

extension SignUpIntent {
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidNickname(_ nickname: String) -> Bool {
        return nickname.count >= 1 && nickname.count <= 30
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegEx = "^01\\d{8,9}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phoneNumber)
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
    
    private func isValidPasswordConfirm(_ passwordConfirm: String) -> Bool {
        return !passwordConfirm.isEmpty && !state.passwordInputText.isEmpty && state.passwordInputText == passwordConfirm
    }
}

extension SignUpIntent {
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        
        guard isValidPhoneNumber(phoneNumber) else { return phoneNumber }
        
        if phoneNumber.count == 10 {
            let formattedNumber = phoneNumber.prefix(3) + "-" + phoneNumber.dropFirst(3).prefix(3) + "-" + phoneNumber.suffix(4)
            return String(formattedNumber)
        } else if phoneNumber.count == 11 {
            let formattedNumber = phoneNumber.prefix(3) + "-" + phoneNumber.dropFirst(3).prefix(4) + "-" + phoneNumber.suffix(4)
            return String(formattedNumber)
        }
    
        return phoneNumber
    }
}

