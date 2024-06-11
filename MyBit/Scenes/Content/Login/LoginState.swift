//
//  LoginState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/11/24.
//

import Foundation

struct LoginState: StateType {
    var isLoading: Bool = false
    var emailInputText: String = ""
    var passwordInputText: String = ""
    var errorMessage: String? = nil
}
