//
//  OnboardingView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI
import KakaoSDKUser
import Combine
import AuthenticationServices

struct OnboardingView: View {
    
    @StateObject private var intent = OnboardingIntent()
    
    @Binding var isOnBoardingPresented: Bool
    @Binding var profileImage: String
    
    @State private var isBottomSheetPresented: Bool = false
    @State private var isLoginViewPresented: Bool = false
    @State private var isSignUpViewPresented: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.customLightGray
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                    .frame(height: 60)
                
                SplashTopView()
                
                Spacer()
                
                CustomButton {
                    isBottomSheetPresented = true
                } label: {
                    Text("시작하기")
                }
                .bottomButtonShape(.brandPoint)
                
                Spacer()
                    .frame(height: 46)
            }
            
            if isBottomSheetPresented {
                BottomSheetView($isBottomSheetPresented, height: 290) {
                    VStack(spacing: 16) {
                        CustomButton {
                            print("Apple으로 계속하기")
                            loginWithAppleID()
                        } label: {
                            HStack{
                                Image(.appleLogo)
                                Text("Apple으로 계속하기")
                            }
                        }
                        .bottomButtonShape(.customBlack)
                        
                        CustomButton {
                            print("카카오톡으로 계속하기")
                            loginWithKakaoTalk()
                        } label: {
                            HStack{
                                Image(.kakaoLogo)
                                Text("카카오톡으로 계속하기")
                                    .foregroundStyle(.customBlack)
                            }
                        }
                        .bottomButtonShape(.customYellow)
                        
                        CustomButton {
                            print("이메일로 계속하기")
                            isLoginViewPresented = true
                        } label: {
                            HStack{
                                Image(.emailIcon)
                                Text("이메일로 계속하기")
                            }
                        }
                        .bottomButtonShape(.brandPoint)
                        
                        CustomButton {
                            print("또는 새롭게 회원가입 하기")
                            isSignUpViewPresented = true
                        } label: {
                            HStack{
                                Text("또는")
                                    .foregroundStyle(.customBlack)
                                Text("새롭게 회원가입 하기")
                                    .foregroundStyle(.brandPoint)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .animation(.interactiveSpring, value: isBottomSheetPresented)
        .sheet(isPresented: $isLoginViewPresented) {
            LoginView(
                isPresented: $isLoginViewPresented,
                isOnBoardingPresented: $isOnBoardingPresented,
                profileImage: $profileImage
            )
        }
        .sheet(isPresented: $isSignUpViewPresented) {
            SignUpView(
                isPresented: $isSignUpViewPresented,
                isOnBoardingPresented: $isOnBoardingPresented,
                profileImage: $profileImage
            )
        }
        .onReceive(Just(intent.state.userInfo)) { newValue in
            if newValue != nil { isOnBoardingPresented = false }
        }
    }
}

extension OnboardingView {
    private func loginWithAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = intent
        authorizationController.presentationContextProvider = intent
        authorizationController.performRequests()
    }
    
    private func loginWithKakaoTalk() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print("Fail to login with KakaoTalk.")
                    print(error)
                }
                else {
                    print("Successfully login with KakaoTak.")
                    
                    intent.send(.loginWithKakao(oauthToken: oauthToken?.accessToken))
                }
            }
        }
    }
}


#Preview {
    OnboardingView(isOnBoardingPresented: .constant(true), profileImage: .constant(""))
}
