//
//  ExchangeState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation

struct ExchangeState: StateType {
    var isLoading: Bool = false
    var currentPriceList: [CurrentPrice] = []
    var errorMessage: String? = nil
}
