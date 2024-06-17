//
//  OnboardingIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/13/24.
//

import Foundation
import Combine
import AuthenticationServices

final class OnboardingIntent: NSObject, IntentType {
    enum Action {
        case loginWithKakao(oauthToken: String?)
    }
    
    @Published private(set) var state = OnboardingState()
    @KeychainStorage(.accessToken) private var accessToken: String = ""
    @KeychainStorage(.refreshToken) private var refreshToken: String = ""
    
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
    
    private func loginwithAppleID(idToken: String, nickname: String?) {
        
        UserManager.loginwithAppleID(idToken: idToken, nickname: nickname)
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

// TODO: - 추후 SOLID 원칙에 의해 다른 곳으로 이관하기
extension OnboardingIntent: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            guard
                let identityToken = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityToken, encoding: .utf8)
            else { return }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName:", fullName)
            print("email: ", email)
            print("identityToken: \(identityTokenString)")
            
            var fullname: String? = nil
            if let familyName = fullName?.familyName, let givenName = fullName?.givenName {
                fullname = familyName + givenName
            } else if let familyName = fullName?.familyName, fullName?.givenName == nil {
                fullname = familyName
            } else if fullName?.familyName == nil, let givenName = fullName?.givenName {
                fullname = givenName
            }
            
            loginwithAppleID(idToken: identityTokenString, nickname: fullname)
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}

extension OnboardingIntent: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { fatalError("No window found.") }
        
        return window
    }
}
