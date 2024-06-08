//
//  Trending.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation

struct Trending: Decodable {
    let coins: [TrendingCoin]
    let nfts: [TrendingNFT]
}

struct TrendingCoin: Decodable {
    let item: Coin
}

struct Coin: Decodable, Identifiable, ItemEssentialElements {
    let id: String // 코인 ID
    let name: String // 코인 이름
    let market_cap_rank: Int? // 코인 랭킹
    let symbol: String // 코인 통화 단위
    let thumb: String // 썸네일용 리소스
    let small: String? // 코인 아이콘 리소스
    let data: CoinData?
    
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
        self.data = try container.decodeIfPresent(CoinData.self, forKey: .data) ?? nil
    }
}

struct CoinData: Decodable {
    let price: Double // 코인 현재가
    let price_change_percentage_24h: TrendingItemDataChange24h
}

struct TrendingItemDataChange24h: Decodable {
    let krw: Double // 코인 변동폭
}

struct TrendingNFT: Decodable, Identifiable, ItemEssentialElements {
    let id: String
    let name: String // NFT 토큰명
    let symbol: String // NFT 통화 단위
    let thumb: String // NFT 아이콘 리소스
    let data: NFTData
}

struct NFTData: Decodable {
    let floor_price: String // NFT 최저가
    let floor_price_in_usd_24h_percentage_change: String // NFT 변동폭
}
