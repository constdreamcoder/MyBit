//
//  DetailState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import Foundation
import SwiftUI
import DGCharts

struct DetailState: StateType {
    var isLoading: Bool = false
    var isFavorite: Bool = false
    var coinMarkets: [Market] = []
    var topViewDatas: TopViewData? = nil
    var middleViewData: [DetailMiddleItem] = [
        DetailMiddleItem(title: "고가", price: 69234243, titleColor: .customRed),
        DetailMiddleItem(title: "저가", price: 69234243, titleColor: .customBlue),
        DetailMiddleItem(title: "신고점", price: 69234243, titleColor: .customRed),
        DetailMiddleItem(title: "신저점", price: 69234243, titleColor: .customBlue)
    ]
    var chartDataEntries: [ChartDataEntry] = []
    var lastUpdatedDate: String = "2/21 11:53:50"
    var errorMessage: String? = nil
}

struct TopViewData {
    let image: String
    let name: String
    let currentPrice: Double
    let priceChangePercentage24h: Double
}

struct DetailMiddleItem {
    let title: String
    var price: Double
    let titleColor: Color
}
