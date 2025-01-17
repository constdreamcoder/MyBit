//
//  TrendingIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation
import Combine

final class TrendingIntent: IntentType {
    
    enum Action {
        case getFavorites
        case getTrending
    }
    
    @Published private(set) var state = TrendingState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .getFavorites:
            getFavorites()
        case .getTrending:
            getTrending()
        }
    }
}

extension TrendingIntent {
    private func getFavorites() {
        state.isLoading = true
        state.errorMessage = nil
        
        let idList: [String] = FavoriteRepository.shared.read().map { $0.id }
        
        if idList.count > 0 {
            CoingeckoManager.fetchCoinMarkets(idList)
                .sink { [weak self] completion in
                    guard let self else { return }
                    
                    if case .failure(let error) = completion {
                        print("errors", error)
                        state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    }
                    state.isLoading = false
                } receiveValue: { [weak self] coinMarkets in
                    guard let self else { return }

                    state.coinMarkets = coinMarkets
                }
                .store(in: &cancelable)
        }
    }
    
    private func getTrending() {
        state.isLoading = true
        state.errorMessage = nil
        
        CoingeckoManager.fetchTrending()
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors",error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] trending in
                guard let self else { return }
                let trendingCoins = trending.coins.map { $0.item }
                let sortedTrendingCoins = trendingCoins.sorted { $0.market_cap_rank ?? -1 < $1.market_cap_rank ?? -1 }
                let rankedTrendingCoins = sortedTrendingCoins.enumerated().map { ($0, $1) }

                state.trendingCoins = Array(rankedTrendingCoins.chunked(into: 3))
                
                let rankedTrendingNFTs = trending.nfts.enumerated().map { ($0, $1) }
                state.trendingNFTs = Array(rankedTrendingNFTs.chunked(into: 3))
            }
            .store(in: &cancelable)
    }
}
