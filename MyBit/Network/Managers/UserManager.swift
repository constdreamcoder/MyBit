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
    
    static func emailValidation(_ email: String) -> AnyPublisher<Bool, NetworkErrors> {
        Future<Bool, NetworkErrors> { promise in
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
                        promise(.success(true))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    static func join(email: String, password: String, nickname: String, phone: String?) -> AnyPublisher<UserInfo, NetworkErrors> {
        return Future<UserInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
            provider.requestPublisher(.join(email: email, password: password, nickname: nickname, phone: phone))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Joined!!")
                    case .failure(let error):
                        print("Join Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(UserInfo.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    static func login(email: String, password: String) -> AnyPublisher<UserInfo, NetworkErrors> {
        return Future<UserInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
            provider.requestPublisher(.login(email: email, password: password))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Logined!!")
                    case .failure(let error):
                        print("Login Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(UserInfo.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }

    static func loginWithKakaTalk(oauthToken: String) -> AnyPublisher<UserInfo, NetworkErrors> {
        return Future<UserInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
            provider.requestPublisher(.loginWithKakaoTalk(oauthToken: oauthToken))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Logined!!")
                    case .failure(let error):
                        print("Login Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(UserInfo.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }

    static func loginwithAppleID(idToken: String, nickname: String?) -> AnyPublisher<UserInfo, NetworkErrors> {
        return Future<UserInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
            provider.requestPublisher(.loginWithAppleID(idToken: idToken, nickname: nickname))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Logined!!")
                    case .failure(let error):
                        print("Login Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(UserInfo.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    static func fetchMyProfile() -> AnyPublisher<MyProfileInfo, NetworkErrors> {
        return Future<MyProfileInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
            provider.requestPublisher(.fetchMyProfile)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Fetch My Profile!!")
                    case .failure(let error):
                        print("Fetch My Profile Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(MyProfileInfo.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    static func editMyProfile(nickname: String? = nil, phone: String? = nil) -> AnyPublisher<MyProfileInfo, NetworkErrors> {
        return Future<MyProfileInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
            provider.requestPublisher(.editMyProfile(nickname: nickname, phone: phone))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Edit My Profile!!")
                    case .failure(let error):
                        print("Edit My Profile Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(MyProfileInfo.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    static func uploadProfile(imageData: Data) -> AnyPublisher<MyProfileInfo, NetworkErrors> {
        return Future<MyProfileInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
            provider.requestPublisher(.uploadProfileImage(imageData: imageData))
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Edit My Profile!!")
                    case .failure(let error):
                        print("Edit My Profile Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(MyProfileInfo.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
}
