//
//  TrendingRankingType.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import Foundation

enum TrendingRankingType {
    case coin(TrendingState.TrendingCoinType)
    case nft(TrendingState.TrendingNFTType)
    
    var index: Int {
        switch self {
        case .coin(let trendingCoinType):
            return trendingCoinType.index
        case .nft(let trendingNFTType):
            return trendingNFTType.index
        }
    }
    
    var item: ItemEssentialElements {
        switch self {
        case .coin(let trendingCoinType):
            return trendingCoinType.coin
        case .nft(let trendingNFTType):
            return trendingNFTType.nft
        }
    }
}
