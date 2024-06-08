//
//  Ticker.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation

struct Ticker: Decodable {
    let type: String
    let code: String
    let trade_price: Double
    let change: String
    let signed_change_price: Double
    let signed_change_rate: Double
    let acc_trade_price_24h: Double
}
