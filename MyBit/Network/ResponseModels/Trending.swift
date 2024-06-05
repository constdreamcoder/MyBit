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
    let item: TrendingCoinItem
}

struct TrendingCoinItem: Decodable {
    let id: String // 코인 ID
    let name: String // 코인 이름
    let symbol: String // 코인 통화 단위
    let small: String // 코인 아이콘 리소스
    let data: TrendingCoinItemData
}

struct TrendingCoinItemData: Decodable {
    let price: Double // 코인 현재가
    let price_change_percentage_24h: TrendingItemDataChange24h
}

struct TrendingItemDataChange24h: Decodable {
    let krw: Double // 코인 변동폭
}
