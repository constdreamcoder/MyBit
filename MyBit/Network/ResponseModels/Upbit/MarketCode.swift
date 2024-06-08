//
//  MarketCode.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation

struct MarketCode: Identifiable, Hashable, Decodable {
    let id = UUID()
    let market: String
    let koreanName: String
    let englishName: String
    
    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.market = try container.decode(String.self, forKey: .market)
        self.koreanName = try container.decode(String.self, forKey: .koreanName)
        self.englishName = try container.decode(String.self, forKey: .englishName)
    }
}
