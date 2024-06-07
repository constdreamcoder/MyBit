//
//  TrendingState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation

struct TrendingState: StateType {
    
    typealias TrendingCoinType = (index: Int, coin: Coin)
    typealias TrendingNFTType = (index: Int, nft: TrendingNFT)
    
    var isLoading: Bool = false
    var trendingCoins: [[TrendingCoinType]] = []
    var trendingNFTs: [[TrendingNFTType]] = []
    var errorMessage: String? = nil
}
