//
//  CurrentPrice.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation

struct CurrentPrice: Identifiable, Hashable, Decodable {
    let id = UUID()
    let market, tradeDate, tradeTime, tradeDateKst: String
    let tradeTimeKst: String
    let tradeTimestamp: Int
    let openingPrice, highPrice, lowPrice, tradePrice: Double
    let prevClosingPrice: Double
    let change: String
    let changePrice, changeRate, signedChangePrice, signedChangeRate: Double
    let tradeVolume, accTradePrice, accTradePrice24H, accTradeVolume: Double
    let accTradeVolume24H, highest52_WeekPrice: Double
    let highest52_WeekDate: String
    let lowest52_WeekPrice: Double
    let lowest52_WeekDate: String
    let timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case market
        case tradeDate = "trade_date"
        case tradeTime = "trade_time"
        case tradeDateKst = "trade_date_kst"
        case tradeTimeKst = "trade_time_kst"
        case tradeTimestamp = "trade_timestamp"
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
        case prevClosingPrice = "prev_closing_price"
        case change
        case changePrice = "change_price"
        case changeRate = "change_rate"
        case signedChangePrice = "signed_change_price"
        case signedChangeRate = "signed_change_rate"
        case tradeVolume = "trade_volume"
        case accTradePrice = "acc_trade_price"
        case accTradePrice24H = "acc_trade_price_24h"
        case accTradeVolume = "acc_trade_volume"
        case accTradeVolume24H = "acc_trade_volume_24h"
        case highest52_WeekPrice = "highest_52_week_price"
        case highest52_WeekDate = "highest_52_week_date"
        case lowest52_WeekPrice = "lowest_52_week_price"
        case lowest52_WeekDate = "lowest_52_week_date"
        case timestamp
    }
    
    init(market: String,
         tradeDate: String = "",
         tradeTime: String = "",
         tradeDateKst: String = "",
         tradeTimeKst: String = "",
         tradeTimestamp: Int = 0,
         openingPrice: Double = 0,
         highPrice: Double = 0,
         lowPrice: Double = 0,
         tradePrice: Double,
         prevClosingPrice: Double = 0,
         change: String,
         changePrice: Double = 0,
         changeRate: Double = 0,
         signedChangePrice: Double,
         signedChangeRate: Double,
         tradeVolume: Double = 0,
         accTradePrice: Double = 0,
         accTradePrice24H: Double,
         accTradeVolume: Double = 0,
         accTradeVolume24H: Double = 0,
         highest52_WeekPrice: Double = 0,
         highest52_WeekDate: String = "",
         lowest52_WeekPrice: Double = 0,
         lowest52_WeekDate: String = "",
         timestamp: Int = 0
    ) {
        self.market = market
        self.tradeDate = tradeDate
        self.tradeTime = tradeTime
        self.tradeDateKst = tradeDateKst
        self.tradeTimeKst = tradeTimeKst
        self.tradeTimestamp = tradeTimestamp
        self.openingPrice = openingPrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.tradePrice = tradePrice
        self.prevClosingPrice = prevClosingPrice
        self.change = change
        self.changePrice = changePrice
        self.changeRate = changeRate
        self.signedChangePrice = signedChangePrice
        self.signedChangeRate = signedChangeRate
        self.tradeVolume = tradeVolume
        self.accTradePrice = accTradePrice
        self.accTradePrice24H = accTradePrice24H
        self.accTradeVolume = accTradeVolume
        self.accTradeVolume24H = accTradeVolume24H
        self.highest52_WeekPrice = highest52_WeekPrice
        self.highest52_WeekDate = highest52_WeekDate
        self.lowest52_WeekPrice = lowest52_WeekPrice
        self.lowest52_WeekDate = lowest52_WeekDate
        self.timestamp = timestamp
    }
}

