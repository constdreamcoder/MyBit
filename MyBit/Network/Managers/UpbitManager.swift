//
//  UpbitManager.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

struct UpbitManager {
    
    static var cancellable = Set<AnyCancellable>()
    
    static func fetchMarketCodes() -> AnyPublisher<[MarketCode], NetworkErrors> {
        Future<[MarketCode], NetworkErrors> { promise in
            let provider = MoyaProvider<UpbitService>()
            provider.requestPublisher(.marketCodes)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Fetch Market Codes!!")
                    case .failure(let error):
                        print("Fetch Market Codes Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode([MarketCode].self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    static func fetchCurrentPrices(_ marketCodes: String) -> AnyPublisher<[CurrentPrice], NetworkErrors> {
        Future<[CurrentPrice], NetworkErrors> { promise in
            let provider = MoyaProvider<UpbitService>()
            provider.requestPublisher(.currentPrices(marketCodes: marketCodes))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Fetch Current Prices !!")
                    case .failure(let error):
                        print("Fetch Current Prices Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode([CurrentPrice].self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
}
