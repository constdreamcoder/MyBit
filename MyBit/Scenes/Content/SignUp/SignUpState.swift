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
    
    var emailDoubleCheckButtonValidation: Bool = false
    var emailValidation: Bool = false
    var nicknameValidation: Bool = false
    var passwordValidation: Bool = false
    var passwordConfirmValidation: Bool = false
    
    var signUpValidation: Bool = false
    
    var userInfo: UserInfo? = nil
    
    var errorMessage: String? = nil
}
