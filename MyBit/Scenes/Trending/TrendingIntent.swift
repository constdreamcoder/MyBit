//
//  TrendingIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation
import Combine

final class TrendingIntent: ObservableObject {
    
    enum Action {
        case getTrending
    }
    
    @Published private(set) var state = TrendingState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .getTrending:
            getTrending()
        }
    }
}

extension TrendingIntent {
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
                print("trending:\(trending)")
                state.trending = trending
            }
            .store(in: &cancelable)
    }
}
