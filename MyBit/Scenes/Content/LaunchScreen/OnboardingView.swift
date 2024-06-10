//
//  OnboardingView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var isFirstLaunching: Bool
    @State private var isBottomSheetPresented: Bool = false
    @State private var isAccountViewPresented: Bool = false
    
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
                        } label: {
                            HStack{
                                Image(.appleLogo)
                                Text("Apple으로 계속하기")
                            }
                        }
                        .bottomButtonShape(.customBlack)
                        
                        CustomButton {
                            print("카카오톡으로 계속하기")
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
                        } label: {
                            HStack{
                                Image(.emailIcon)
                                Text("이메일로 계속하기")
                            }
                        }
                        .bottomButtonShape(.brandPoint)
                        
                        CustomButton {
                            print("또는 새롭게 회원가입 하기")
                            isAccountViewPresented = true
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
        .sheet(isPresented: $isAccountViewPresented, content: {
            SignUpView(isPresented: $isAccountViewPresented)
        })
    }
}

#Preview {
    OnboardingView(isFirstLaunching: .constant(true))
}
