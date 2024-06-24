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
    
    static var cancelable = Set<AnyCancellable>()

    static func emailValidation(_ email: String) -> AnyPublisher<Bool, NetworkErrors> {
        Future<Bool, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [LoggerPlugin()])
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
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }
    
    static func join(email: String, password: String, nickname: String, phone: String?) -> AnyPublisher<UserInfo, NetworkErrors> {
        return Future<UserInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [LoggerPlugin()])
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
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }
    
    static func login(email: String, password: String) -> AnyPublisher<UserInfo, NetworkErrors> {
        return Future<UserInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [LoggerPlugin()])
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
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }

    static func loginWithKakaTalk(oauthToken: String) -> AnyPublisher<UserInfo, NetworkErrors> {
        return Future<UserInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [LoggerPlugin()])
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
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }

    static func loginwithAppleID(idToken: String, nickname: String?) -> AnyPublisher<UserInfo, NetworkErrors> {
        return Future<UserInfo, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [LoggerPlugin()])
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
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }
    
    static func fetchMyProfile() -> AnyPublisher<MyProfileInfo, NetworkErrors> {
        return Future<MyProfileInfo, NetworkErrors> { promise in
            let session = Session(interceptor: TokenRefresher())
            let provider = MoyaProvider<UserService>(session: session, plugins: [LoggerPlugin()])
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
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }
    
    static func editMyProfile(nickname: String? = nil, phone: String? = nil) -> AnyPublisher<MyProfileInfo, NetworkErrors> {
        return Future<MyProfileInfo, NetworkErrors> { promise in
            let session = Session(interceptor: TokenRefresher())
            let provider = MoyaProvider<UserService>(session: session, plugins: [LoggerPlugin()])
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
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }
    
    static func uploadProfile(imageData: Data) -> AnyPublisher<MyProfileInfo, NetworkErrors> {
        return Future<MyProfileInfo, NetworkErrors> { promise in
            let session = Session(interceptor: TokenRefresher())
            let provider = MoyaProvider<UserService>(session: session, plugins: [LoggerPlugin()])
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
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }
    
    static func refreshToken() -> AnyPublisher<RefreshedToken, NetworkErrors> {
        return Future<RefreshedToken, NetworkErrors> { promise in
            let provider = MoyaProvider<UserService>(plugins: [LoggerPlugin()])
            provider.requestPublisher(.refreshToken)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Refresh Token!!")
                    case .failure(let error):
                        print("Refresh Token Error", error)
                        promise(.failure(.networkError))
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let result = try JSONDecoder().decode(RefreshedToken.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }
    
    static func logout() -> AnyPublisher<Bool, NetworkErrors> {
        return Future<Bool, NetworkErrors> { promise in
            let session = Session(interceptor: TokenRefresher())
            let provider = MoyaProvider<UserService>(session: session, plugins: [LoggerPlugin()])
            provider.requestPublisher(.logout)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Successfully Logged out!!")
                    case .failure(let error):
                        print("Log-out Error", error)
                    }
                } receiveValue: { response in
                    do {
                        let data = try response.filterSuccessfulStatusCodes()
                        if data.statusCode == 200 {
                            promise(.success(true))
                        }
                    } catch {
                        promise(.failure(.networkError))
                    }
                }.store(in: &cancelable)
        }.eraseToAnyPublisher()
    }
}
