//
//  SignUpView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI
import Combine

struct SignUpView: View {
    
    @StateObject private var intent = SignUpIntent()
    @Binding var isPresented: Bool
    @Binding var isOnBoardingPresented: Bool
    
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
                    isRightButtonDisable: !intent.state.emailDoubleCheckButtonValidation,
                    textFieldGetter: { intent.state.emailInputText },
                    textFieldSetter: { intent.send(.writeEmail(text: $0)) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: { intent.send(.emailDoubleCheck) }
                )
                .keyboardType(.emailAddress)
                
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
                .keyboardType(.numberPad)
                .onReceive(Just(intent.state.phoneNumberInputText)) { newValue in
                    let filtered = newValue.filter { "0123456789-".contains($0) }
                    if filtered != newValue {
                        intent.send(.writePhoneNumber(text: filtered))
                    }
                }
                
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isOnBoardingPresented = false
                    }
                    intent.send(.join)
                } label: {
                    Text("가입하기")
                }
                .bottomButtonShape(intent.state.signUpValidation ? .brandPoint : .customGray)
                .disabled(!intent.state.signUpValidation)
            }
        }
    }
}

#Preview {
    SignUpView(isPresented: .constant(true), isOnBoardingPresented: .constant(true))
}
