//
//  SearchIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import Foundation
import Combine

final class SearchIntent: ObservableObject {
    
    enum Action {
        case searchCoins(query: String)
    }
    
    @Published private(set) var state = SearchState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .searchCoins(let query):
            searchCoins(query)
        }
    }
}

extension SearchIntent {
    private func searchCoins(_ query: String) {
        state.isLoading = true
        state.errorMessage = nil
        
        CoingeckoManager.searchBitcoins(query)
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors", error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] searchedCoins in
                guard let self else { return }
                dump("search:\(searchedCoins)")
                state.searchedCoins = searchedCoins
            }
            .store(in: &cancelable)
    }
}
