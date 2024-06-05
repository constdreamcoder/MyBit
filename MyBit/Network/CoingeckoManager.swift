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
    
    static func fetchTrending() -> AnyPublisher<[TrendingCoin], NetworkErrors> {
        Future<[TrendingCoin], NetworkErrors> { promise in
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
                        print(result)
                        promise(.success(result.coins))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()

    }
}
