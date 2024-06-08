//
//  Market.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import Foundation

struct Market: Decodable, ItemEssentialElements {    
    let id: String
    let symbol: String
    let name: String
    let thumb: String
    let current_price: Double
    let price_change_percentage_24h: Double
    let low_24h: Double
    let high_24h: Double
    let ath: Double
    let ath_date: String
    let atl: Double
    let atl_date: String
    let last_updated: String
    let sparkline_in_7d: SparklineIn7D
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case thumb = "image"
        case current_price
        case price_change_percentage_24h
        case low_24h
        case high_24h
        case ath
        case ath_date
        case atl
        case atl_date
        case last_updated
        case sparkline_in_7d
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.name = try container.decode(String.self, forKey: .name)
        self.thumb = try container.decode(String.self, forKey: .thumb)
        self.current_price = try container.decode(Double.self, forKey: .current_price)
        self.price_change_percentage_24h = try container.decode(Double.self, forKey: .price_change_percentage_24h)
        self.low_24h = try container.decode(Double.self, forKey: .low_24h)
        self.high_24h = try container.decode(Double.self, forKey: .high_24h)
        self.ath = try container.decode(Double.self, forKey: .ath)
        self.ath_date = try container.decode(String.self, forKey: .ath_date)
        self.atl = try container.decode(Double.self, forKey: .atl)
        self.atl_date = try container.decode(String.self, forKey: .atl_date)
        self.last_updated = try container.decode(String.self, forKey: .last_updated)
        self.sparkline_in_7d = try container.decode(SparklineIn7D.self, forKey: .sparkline_in_7d)
    }
}

struct SparklineIn7D: Decodable {
    let price: [Double]
}
