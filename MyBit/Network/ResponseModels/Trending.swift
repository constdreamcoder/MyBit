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

struct Coin: Decodable {
    let id: String // 코인 ID
    let name: String // 코인 이름
    let market_cap_rank: Int? // 코인 랭킹
    let symbol: String // 코인 통화 단위
    let thumb: String // 썸네일용 리소스
    let small: String? // 코인 아이콘 리소스
    let data: TrendingCoinItemData?
}

struct TrendingCoinItemData: Decodable {
    let price: Double // 코인 현재가
    let price_change_percentage_24h: TrendingItemDataChange24h
}

struct TrendingItemDataChange24h: Decodable {
    let krw: Double // 코인 변동폭
}
