//
//  SocialLoginLogo.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import Foundation

enum SocialLoginLogo: String {
    case apple = "apple"
    case kakao = "kakao"
    case none = "none"
    
    var image: String? {
        switch self {
        case .apple:
            return "appleIDLogin"
        case .kakao:
            return "kakaoLogin"
        case .none:
            return ""
        }
    }
}
