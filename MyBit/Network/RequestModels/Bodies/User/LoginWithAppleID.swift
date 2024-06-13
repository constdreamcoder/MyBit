//
//  LoginWithAppleID.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/13/24.
//

import Foundation

struct LoginWithAppleID: Encodable {
    let idToken: String
    let nickname: String?
    let deviceToken: String?
}
