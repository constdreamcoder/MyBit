//
//  LoginView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/11/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var intent = LoginIntent()
    @Binding var isPresented: Bool
    @Binding var isOnOnBoarding: Bool
    
    var body: some View {
        ZStack {
            
            Color.customLightGray
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                NavigationBarForCreatingNewFeature(title: "로그인", isPresented: $isPresented)
                
                InputView(
                    title: "이메일",
                    placeholder: "이메일을 입력하세요",
                    textFieldGetter: { intent.state.emailInputText },
                    textFieldSetter: { intent.send(.writeEmail(text: $0)) },
                    secureFieldGetter: {""},
                    secureFieldSetter: { _ in }
                )
                
                InputView(
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력하세요",
                    isSecure: true,
                    textFieldGetter: { "" },
                    textFieldSetter: { _ in },
                    secureFieldGetter: { intent.state.passwordInputText },
                    secureFieldSetter: { intent.send(.writePassword(text: $0)) }
                )
                
                Spacer()
                
                CustomButton {
                    print("로그인")
                    isOnOnBoarding = false
                } label: {
                    Text("로그인")
                }
                .bottomButtonShape(.brandPoint)
            }
        }
        
    }
}

#Preview {
    LoginView(isPresented: .constant(true), isOnOnBoarding: .constant(true))
}
