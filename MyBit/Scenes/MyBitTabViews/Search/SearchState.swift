//
//  SearchState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import Foundation

struct SearchState: StateType {
    var isLoading: Bool = false
    var searchedCoins: [SearchedCoin] = []
    var errorMessage: String? = nil
}

struct SearchedCoin {
    var coin: Coin
    var isFavorite: Bool
    
    init(coin: Coin, isFavorite: Bool = false) {
        self.coin = coin
        self.isFavorite = isFavorite
    }
}
