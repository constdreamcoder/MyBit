//
//  Join.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/12/24.
//

import Foundation

struct Join: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String?
    let deviceToken: String?
}
