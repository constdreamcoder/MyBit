//
//  LoginView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/11/24.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @StateObject private var intent = LoginIntent()
    @Binding var isPresented: Bool
    @Binding var isOnBoardingPresented: Bool
    
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
                    textFieldSetter: { intent.send(.write(inputKind: .email(input: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {}
                )
                
                InputView(
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력하세요",
                    isSecure: true,
                    textFieldGetter: { "" },
                    textFieldSetter: { _ in },
                    secureFieldGetter: { intent.state.passwordInputText },
                    secureFieldSetter: { intent.send(.write(inputKind: .password(input: $0))) },
                    rightButtonAction: {}
                )
                
                Spacer()
                
                CustomButton {
                    print("로그인")
                    intent.send(.login)
                } label: {
                    Text("로그인")
                }
                .bottomButtonShape(intent.state.loginValidation ? .brandPoint : .customGray)
                .disabled(!intent.state.loginValidation)
            }
        }
        .onReceive(Just(intent.state.userInfo)) { newValue in
            if newValue != nil { isOnBoardingPresented = false }
        }
        
    }
}

#Preview {
    LoginView(isPresented: .constant(true), isOnBoardingPresented: .constant(true))
}
