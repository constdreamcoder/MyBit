//
//  AppIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/18/24.
//

import SwiftUI
import Combine

final class AppIntent: IntentType {
    enum Action {
        case isLogin
    }
    
    @Published private(set) var state = AppState()
    
    var cancelable = Set<AnyCancellable>()
    
    func send(_ action: Action) {
        switch action {
        case .isLogin:
            checkLogin()
        }
    }
}

extension AppIntent {
    private func checkLogin() {
        
        if KeychainManager.read(key: .accessToken) != nil {
            // 로그인
            UserManager.refreshToken()
                .sink { [weak self] completion in
                    guard let
                            self else { return }
                    
                    if case .failure(let error) = completion {
                        print("errors", error)
                        state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    }
                    state.isLoading = false
                } receiveValue: { [weak self] refreshedToken in
                    guard let self else { return }
                    

                    KeychainManager.create(key: .accessToken, value: refreshedToken.accessToken)
                    
                    state.isLogin = true
                }
                .store(in: &cancelable)
        } else {
            // 로그 아웃
            state.isLogin = false
        }
    }
}
