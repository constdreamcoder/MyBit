//
//  Login.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/12/24.
//

import Foundation

struct Login: Encodable {
    let email: String
    let password: String
    let deviceToken: String?
}
