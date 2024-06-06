//
//  SearchState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import Foundation

struct SearchState: StateType {
    var isLoading: Bool = false
    var searchedCoins: [Coin] = []
    var errorMessage: String? = nil
}
