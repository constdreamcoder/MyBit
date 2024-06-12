//
//  UserService.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/11/24.
//

import Foundation
import Moya

enum UserService {
    case validate(email: String)
    case join(email: String, password: String, nickname: String, phone: String?)
}

extension UserService: TargetType {
    var baseURL: URL { URL(string: APIKeys.userBaseURL)! }
    
    var path: String {
        switch self {
        case .validate:
            return "/users/validation/email"
        case .join:
            return "/users/join"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validate, .join:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .validate(let email):
            let emailValidation = EmailValidation(email: email)
            return .requestJSONEncodable(emailValidation)
        case .join(let email, let passowrd, let nickname, let phone):
            let join = Join(email: email, password: passowrd, nickname: nickname, phone: phone, deviceToken: APIKeys.sampleDeviceToken)
            return .requestJSONEncodable(join)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "SesacKey": APIKeys.sesacKey
        ]
    }
}

