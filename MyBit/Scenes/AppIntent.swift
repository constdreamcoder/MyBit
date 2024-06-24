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
        case showLogoutAlert
        case dismissLogoutAlert
        case logout
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
        case .showLogoutAlert:
            showLogutAlert()
        case .dismissLogoutAlert:
            dismissLogoutAlert()
        case .logout:
            logout()
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
    
    private func showLogutAlert() {
        state.showLogutAlert = true
    }
    
    private func dismissLogoutAlert() {
        state.showLogutAlert = false
    }
    
    private func logout() {
        print("로그아웃")
        
        UserManager.logout()
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors", error)
                    state.errorMessage = "Failed to log out: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] success in
                guard let self else { return }

                if success {
                    state.showLogutAlert = false
                    KeychainManager.deleteAll()
                    state.isLogin = false
                }
            }
            .store(in: &cancelable)
    }
}

private extension AppIntent {
    @objc func goBackToOnboardingView(notification: Notification) {
        if let userInfo = notification.userInfo,
           let _ = userInfo["goBackToOnboardingViewTrigger"] as? Bool {
            state.isLogin = false
        }
    }
}
