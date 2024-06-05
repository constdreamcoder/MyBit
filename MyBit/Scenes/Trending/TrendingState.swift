//
//  TrendingState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation

struct TrendingState {
    var isLoading: Bool = false
    var trending: [TrendingCoin] = []
    var errorMessage: String? = nil
}
