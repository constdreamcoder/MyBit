//
//  MyProfileInfo.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import Foundation

struct MyProfileInfo: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: SocialLoginLogo?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case user_id
        case email
        case nickname
        case profileImage
        case phone
        case provider = "provider"
        case createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        let provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.provider = SocialLoginLogo(rawValue: provider)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
