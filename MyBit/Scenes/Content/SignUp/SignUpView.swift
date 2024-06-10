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
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.customLightGray
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 24) {
                        InputView(
                            title: "이메일",
                            placeholder: "이메일을 입력하세요",
                            inputText: intent.state.emailInputText,
                            intent: intent,
                            showRightButton: true
                        )
                        
                        InputView(
                            title: "닉네임",
                            placeholder: "닉네임을 입력하세요",
                            inputText: intent.state.nicknameInputText,
                            intent: intent
                        )
                        
                        InputView(
                            title: "연락처",
                            placeholder: "전화번호를 입력하세요",
                            inputText: intent.state.phoneNumberInputText,
                            intent: intent
                        )
                        
                        InputView(
                            title: "비밀번호",
                            placeholder: "비밀번호를 입력하세요",
                            inputText: intent.state.passwordInputText,
                            intent: intent,
                            isSecure: true
                        )
                        
                        InputView(
                            title: "비밀번호 확인",
                            placeholder: "비밀번호를 한 번 더 입력하세요",
                            inputText: intent.state.passwordConfirmInputText,
                            intent: intent,
                            isSecure: true
                        )
                        
                        Spacer()
                        
                        CustomButton {
                            print("가입하기")
                        } label: {
                            Text("가입하기")
                        }
                        .bottomButtonShape(.brandPoint)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        print("dismiss")
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.customBlack)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        BottomViewGrabber()
                        Text("회원가입")
                            .font(.system(size: 17, weight: .bold))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}


#Preview {
    SignUpView(isPresented: .constant(true))
}
