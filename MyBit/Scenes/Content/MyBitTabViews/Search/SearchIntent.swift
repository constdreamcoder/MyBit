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
        case favoriteButtonTap(tappedCoin: SearchedCoin)
        case refresh
    }
    
    @Published private(set) var state = SearchState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .searchCoins(let query):
            searchCoins(query)
        case .favoriteButtonTap(let tappedCoin):
            favoriteButtonTapped(tappedCoin)
        case .refresh:
            refresh()
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
                state.searchedCoins = searchedCoins.map { coin in
                    let isFavorite = FavoriteRepository.shared.read().contains(where: { $0.id == coin.id})
                    return SearchedCoin(coin: coin, isFavorite: isFavorite)
                }
            }
            .store(in: &cancelable)
    }
    
    private func favoriteButtonTapped(_ tappedCoin: SearchedCoin) {
        if FavoriteRepository.shared.read().contains(where: { $0.id == tappedCoin.coin.id }) {
            guard let tappedFavorite = FavoriteRepository.shared.read().first(where: { $0.id == tappedCoin.coin.id }) else { return }
            FavoriteRepository.shared.delete(tappedFavorite)
            FavoriteRepository.shared.getLocationOfDefaultRealm()
        } else {
            let favorite = Favorite(
                id: tappedCoin.coin.id,
                name: tappedCoin.coin.name,
                symbol: tappedCoin.coin.symbol,
                imageURLString: tappedCoin.coin.thumb
            )
            FavoriteRepository.shared.write(favorite)
            FavoriteRepository.shared.getLocationOfDefaultRealm()
        }
        
        state.searchedCoins = state.searchedCoins.map {
            if $0.coin.id == tappedCoin.coin.id {
                var updatedTappendCoin = tappedCoin
                updatedTappendCoin.isFavorite.toggle()
                return updatedTappendCoin
            } else {
                return $0
            }
        }
    }
    
    private func refresh() {
        state.searchedCoins = state.searchedCoins.map { searchedCoin in
            var refreshedSearchCoin = searchedCoin
            
            if FavoriteRepository.shared.read().contains(where: { $0.id == searchedCoin.coin.id }) {
                refreshedSearchCoin.isFavorite = true
            } else {
                refreshedSearchCoin.isFavorite = false
            }
            return refreshedSearchCoin
        }
    }
}
