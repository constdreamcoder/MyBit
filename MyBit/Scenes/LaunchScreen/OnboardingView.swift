//
//  OnboardingView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var isFirstLaunching: Bool
    
    var body: some View {
        
        ZStack {
            Color.customLightGray
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                    .frame(height: 60)
                
                SplashTopView()
                
                Spacer()
                
                
                Button {
                    isFirstLaunching = false
                } label: {
                    Text("시작하기")
                        .foregroundStyle(.customWhite)
                        .font(.system(size: 22, weight: .semibold))
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .background(.brandPoint)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .padding(.horizontal, 16)
                }
                
                Spacer()
                    .frame(height: 24)
            }
        }
    }
}

#Preview {
    OnboardingView(isFirstLaunching: .constant(true))
}
