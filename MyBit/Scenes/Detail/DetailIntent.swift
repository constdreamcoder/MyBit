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
                state.coinMarkets = coinMarkets
            }
            .store(in: &cancelable)
    }
}

