//
//  DetailState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import Foundation

struct DetailState: StateType {
    var isLoading: Bool = false
    var coinMarkets: [Market] = []
    var errorMessage: String? = nil
}
