//
//  UserManager.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/11/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

struct UserManager {
    
    static var cancellable = Set<AnyCancellable>()
    
    static func emailValidation(_ email: String) -> AnyPublisher<String, NetworkErrors> {
        Future<String, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
            provider.requestPublisher(.validate(email: email))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Validate Email!!")
                    case .failure(let error):
                        print("Validate Email Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let _ = try response.filterSuccessfulStatusCodes()
                        promise(.success("성공"))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
}
