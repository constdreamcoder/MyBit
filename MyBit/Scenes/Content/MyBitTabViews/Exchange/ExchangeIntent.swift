//
//  ExchangeIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation
import Combine

final class ExchangeIntent: IntentType {
    
    enum Action {
        case getCurrentPrices
    }
    
    @Published private(set) var state = ExchangeState()
    
    var cancelable = Set<AnyCancellable>()
        
    func send(_ action: Action) {
        switch action {
        case .getCurrentPrices:
            getMarketCodeList()
        }
    }
}

extension ExchangeIntent {
    private func getRealtimeTickers(_ marketCodeList: [MarketCode]) {
        WebSocketManager.shared.openWebSocket()
        
        let marketCodeIdList = marketCodeList.map { $0.market }
        WebSocketManager.shared.send(
            """
            [{"ticket":"test"},{"type":"ticker","codes":\(marketCodeIdList)}]
            """
        )
        
        WebSocketManager.shared.tickerSbj
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                guard let self else { return }
                print("ticker>>>>", ticker)
                state.currentPriceList = state.currentPriceList.map {
                    if $0.market == ticker.code {
                        return CurrentPrice(
                            market: ticker.code,
                            tradePrice: ticker.trade_price,
                            change: CurrentPrice.Change(rawValue: ticker.change) ?? .even,
                            signedChangePrice: ticker.signed_change_price,
                            signedChangeRate: ticker.signed_change_rate,
                            accTradePrice24H: ticker.acc_trade_price_24h
                        )
                    } else {
                        return $0
                    }
                }.sorted { $0.accTradePrice24H > $1.accTradePrice24H }
            }
            .store(in: &cancelable)
    }
    
    private func getMarketCodeList() {
        state.isLoading = true
        state.errorMessage = nil
        
        // TODO: - 추후 async await로 전환 시도하기
        UpbitManager.fetchMarketCodes()
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors", error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] marketCodeList in
                guard let self else { return }
                
                getRealtimeTickers(marketCodeList)
                getCurrentPrices(marketCodeList)
            }
            .store(in: &cancelable)
    }
    
    private func getCurrentPrices(_ marketCodeList: [MarketCode]) {
        state.isLoading = true
        state.errorMessage = nil
        
        let combinedMarketCodeList = marketCodeList.map { $0.market }.joined(separator: ",")
        UpbitManager.fetchCurrentPrices(combinedMarketCodeList)
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors", error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] currentPriceList in
                guard let self else { return }
                
                state.currentPriceList = currentPriceList.sorted { $0.accTradePrice24H > $1.accTradePrice24H }
            }
            .store(in: &cancelable)
    }
}
