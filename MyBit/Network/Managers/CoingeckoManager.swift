//
//  CoingeckoManager.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

struct CoingeckoManager {
    
    static var cancellable = Set<AnyCancellable>()
    
    static func fetchTrending() -> AnyPublisher<Trending, NetworkErrors> {
        Future<Trending, NetworkErrors> { promise in
            let provider = MoyaProvider<CoingeckoAPI>()
            provider.requestPublisher(.trending)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Fetch Trending!!")
                    case .failure(let error):
                        print("Fetch Trending Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(Trending.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    static func searchBitcoins(_ query: String) -> AnyPublisher<[Coin], NetworkErrors> {
        Future<[Coin], NetworkErrors> { promise in
            let provider = MoyaProvider<CoingeckoAPI>()
            provider.requestPublisher(.search(query: query))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Search Coins!!")
                    case .failure(let error):
                        print("Search Coins Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(Search.self, from: data)
                        promise(.success(result.coins))
                    } catch {
                        print("real error", error)
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    static func fetchCoinMarkets(_ idList: [String]) -> AnyPublisher<[Market], NetworkErrors> {
        Future<[Market], NetworkErrors> { promise in
            let provider = MoyaProvider<CoingeckoAPI>()
            let ids = idList.joined(separator: ",")
            provider.requestPublisher(.coinMarket(ids: ids))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Fatch Coin Markets!!")
                    case .failure(let error):
                        print("Fatch Coin Markets Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode([Market].self, from: data)
                        promise(.success(result))
                    } catch {
                        print("real error", error)
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
}
