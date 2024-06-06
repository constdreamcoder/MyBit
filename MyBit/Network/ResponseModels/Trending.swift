//
//  Trending.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation

struct Trending: Decodable {
    let coins: [TrendingCoin]
}

struct TrendingCoin: Decodable {
    let item: Coin
}

struct Coin: Decodable, Identifiable {
    let id: String // 코인 ID
    let name: String // 코인 이름
    let market_cap_rank: Int? // 코인 랭킹
    let symbol: String // 코인 통화 단위
    let thumb: String // 썸네일용 리소스
    let small: String? // 코인 아이콘 리소스
    let data: TrendingCoinItemData?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case market_cap_rank
        case symbol
        case thumb
        case small
        case data
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.market_cap_rank = try container.decodeIfPresent(Int.self, forKey: .market_cap_rank) ?? -1
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.thumb = try container.decode(String.self, forKey: .thumb)
        self.small = try container.decodeIfPresent(String.self, forKey: .small) ?? ""
        self.data = try container.decodeIfPresent(TrendingCoinItemData.self, forKey: .data) ?? nil
    }
}

struct TrendingCoinItemData: Decodable {
    let price: Double // 코인 현재가
    let price_change_percentage_24h: TrendingItemDataChange24h
}

struct TrendingItemDataChange24h: Decodable {
    let krw: Double // 코인 변동폭
}
