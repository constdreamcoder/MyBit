//
//  FavoriteState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation

struct FavoriteState: StateType {
    var isLoading: Bool = false
    var coinMarkets: [Market] = []
    var errorMessage: String? = nil
}
