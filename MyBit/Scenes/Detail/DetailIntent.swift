//
//  DetailIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import Foundation
import Combine

final class DetailIntent: ObservableObject {
    
    enum Action {
        case getCoinMarkets(idList: [String])
    }
    
    @Published private(set) var state = DetailState()
    
    var cancelable = Set<AnyCancellable>()
        
    func send(_ action: Action) {
        switch action {
        case .getCoinMarkets(let idList):
            getCoinMarkets(idList)
        }
    }
}

extension DetailIntent {
    private func getCoinMarkets(_ idList: [String]) {
        state.isLoading = true
        state.errorMessage = nil
        
        CoingeckoManager.fetchCoinMarkets(idList)
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors",error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] coinMarkets in
                guard let self else { return }
                print("coinMarkets:\(coinMarkets)")
                let market = coinMarkets[0]
                state.topViewDatas = .init(
                    image: market.image,
                    name: market.name,
                    currentPrice: market.current_price,
                    priceChangePercentage24h: market.price_change_percentage_24h
                )
                
                state.middleViewData[0].price = market.high_24h
                state.middleViewData[1].price = market.low_24h
                state.middleViewData[2].price = market.ath
                state.middleViewData[3].price = market.atl
                
                for (index, price) in market.sparkline_in_7d.price.enumerated() {
                    state.chartDataEntries.append(.init(x: Double(index), y: price))
                }
                
                state.lastUpdatedDate = market.last_updated
            }
            .store(in: &cancelable)
    }
}

