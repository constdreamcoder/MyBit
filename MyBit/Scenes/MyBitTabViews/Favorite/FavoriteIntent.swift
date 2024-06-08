//
//  FavoriteIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation
import Combine

final class FavoriteIntent: ObservableObject {
    
    enum Action {
        case getFavorites
    }
    
    @Published private(set) var state = FavoriteState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .getFavorites:
            getFavorites()
        }
    }
}

extension FavoriteIntent {
    private func getFavorites() {
        state.isLoading = true
        state.errorMessage = nil
        
        let ids: [String] = FavoriteRepository.shared.read().map { $0.id }
        
        CoingeckoManager.fetchCoinMarkets(ids)
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

