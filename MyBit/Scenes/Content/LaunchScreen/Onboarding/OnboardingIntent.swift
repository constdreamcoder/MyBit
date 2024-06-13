//
//  OnboardingIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/13/24.
//

import Foundation
import Combine

final class OnboardingIntent: IntentType {
    enum Action {
        case loginWithKakao(oauthToken: String?)
    }
    
    @Published private(set) var state = OnboardingState()
    @KeychainStorage(key: .accessToken) private var accessToken: String?
    @KeychainStorage(key: .refreshToken) private var refreshToken: String?
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .loginWithKakao(let oauthToken):
            loginWithKakao(oauthToken) // TODO: - 과도한 네트워크 요청 방지를 위한 debounce 추가하기
        }
    }
    
}

extension OnboardingIntent {
    private func loginWithKakao(_ oauthToken: String?) {
        
        guard let oauthToken else { return }
        
        UserManager.loginWithKakaTalk(oauthToken: oauthToken)
            .sink { [weak self] completion in
                guard let
                        self else { return }
                
                if case .failure(let error) = completion {
                    print("errors", error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] userInfo in
                guard let self else { return }
                
                print(userInfo)
                
                accessToken = userInfo.token.accessToken
                refreshToken = userInfo.token.refreshToken
                
                state.userInfo = userInfo
            }
            .store(in: &cancelable)
    }
}
