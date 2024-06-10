//
//  SignUpState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import Foundation

struct SignUpState: StateType {
    var isLoading: Bool = false
    var emailInputText: String = ""
    var nicknameInputText: String = ""
    var phoneNumberInputText: String = ""
    var passwordInputText: String = ""
    var passwordConfirmInputText: String = ""
    var errorMessage: String? = nil
}