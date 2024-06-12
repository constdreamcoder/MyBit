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
}

extension UserService: TargetType {
    var baseURL: URL { URL(string: APIKeys.userBaseURL)! }
    
    var path: String {
        switch self {
        case .validate:
            return "/users/validation/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validate:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .validate(let email):
            let emailValidation = EmailValidation(email: email)
            return .requestJSONEncodable(emailValidation)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "SesacKey": APIKeys.sesacKey
        ]
    }
}

