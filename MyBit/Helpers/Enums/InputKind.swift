//
//  InputKind.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import Foundation

enum InputKind {
    case email(input: String)
    case nickname(input: String)
    case phone(input: String)
    case password(input: String)
    case passwordConfirm(input: String, password: String?)
    
    var isValid: Bool {
        switch self {
        case .email(let input):
            isValidEmail(input)
        case .nickname(let input):
            isValidNickname(input)
        case .phone(let input):
            isValidPhoneNumber(input)
        case .password(let input):
            isValidPassword(input)
        case .passwordConfirm(let input, let password):
            isValidPasswordConfirm(input, password: password)
        }
    }
    
    var formatPhoneNumber: String {
        switch self {
        case .phone(let input):
            return formatPhoneNumber(input)
        default: return ""
        }
    }
}

extension InputKind {
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidNickname(_ nickname: String) -> Bool {
        return nickname.count >= 1 && nickname.count <= 30
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        
        let phone: String = phoneNumber
        
        let phoneRegEx = "^01\\d{8,9}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
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
    
    private func isValidPasswordConfirm(_ passwordConfirm: String, password: String?) -> Bool {
        guard let password else { return false }
        return !passwordConfirm.isEmpty && password == passwordConfirm
    }
    
    
    static func isValidFormattedPhoneNumber(_ phoneNumber: String) -> Bool {
        let regex = "^01\\d{1}-\\d{3,4}-\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phoneNumber)
    }
}

extension InputKind {
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        
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
