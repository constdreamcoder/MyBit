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
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(goBackToOnboardingView), name: .GoBackToOnboardingView, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .GoBackToOnboardingView, object: nil)
    }
    
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
            state.isLogin = true
        } else {
            // 로그 아웃
            state.isLogin = false
        }
    }
}

private extension AppIntent {
    @objc func goBackToOnboardingView(notification: Notification) {
        if let userInfo = notification.userInfo,
           let goBackToOnboardingViewTrigger = userInfo["goBackToOnboardingViewTrigger"] as? Bool {
            state.isLogin = false
        }
    }
}
