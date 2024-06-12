//
//  SignUpView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var intent = SignUpIntent()
    @Binding var isPresented: Bool
    @Binding var isOnOnBoarding: Bool
    
    var body: some View {
        ZStack {
            
            Color.customLightGray
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                NavigationBarForCreatingNewFeature(title: "회원가입", isPresented: $isPresented)
                
                InputView(
                    title: "이메일",
                    placeholder: "이메일을 입력하세요",
                    showRightButton: true,
                    isRightButtonDisable: !intent.state.emailDoubleCheckValidation,
                    textFieldGetter: { intent.state.emailInputText },
                    textFieldSetter: { intent.send(.writeEmail(text: $0)) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in }, 
                    rightButtonAction: { intent.send(.emailDoubleCheck) }
                )
                
                InputView(
                    title: "닉네임",
                    placeholder: "닉네임을 입력하세요",
                    textFieldGetter: { intent.state.nicknameInputText },
                    textFieldSetter: { intent.send(.writeNickname(text: $0)) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in }, 
                    rightButtonAction: {}
                )
                
                InputView(
                    title: "연락처",
                    placeholder: "전화번호를 입력하세요",
                    textFieldGetter: { intent.state.phoneNumberInputText },
                    textFieldSetter: { intent.send(.writePhoneNumber(text: $0)) },
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
                    secureFieldSetter: { intent.send(.writePassword(text: $0)) }, 
                    rightButtonAction: {}
                )
                
                InputView(
                    title: "비밀번호 확인",
                    placeholder: "비밀번호를 한 번 더 입력하세요",
                    isSecure: true,
                    textFieldGetter: { "" },
                    textFieldSetter: { _ in },
                    secureFieldGetter: { intent.state.passwordConfirmInputText },
                    secureFieldSetter: { intent.send(.writePasswordConfirm(text: $0)) }, 
                    rightButtonAction: {}
                )
                
                Spacer()
                
                CustomButton {
                    print("가입하기")
                    isOnOnBoarding = false
                } label: {
                    Text("가입하기")
                }
                .bottomButtonShape(.brandPoint)
            }
        }
    }
}

#Preview {
    SignUpView(isPresented: .constant(true), isOnOnBoarding: .constant(true))
}
