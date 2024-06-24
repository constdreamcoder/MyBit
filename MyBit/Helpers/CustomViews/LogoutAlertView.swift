//
//  AlertView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/24/24.
//

import SwiftUI

struct LogoutAlertView: View {    
    let cancelAction: () -> Void
    let logoutAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.4).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                LogoutAlert(
                    cancelAction: cancelAction,
                    logoutAction: logoutAction
                )
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LogoutAlertView(cancelAction: {}, logoutAction: {})
}


struct AlertButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
        }
    }
}

struct LogoutAlert: View {
    
    let cancelAction: () -> Void
    let logoutAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("로그아웃")
                .font(.system(size: 14, weight: .bold))
            
            Text("정말 로그아웃 할까요?")
                .font(.system(size: 13))
            
            HStack {
                AlertButton(
                    title: "취소",
                    backgroundColor: .gray,
                    action: cancelAction 
                )
                
                AlertButton(
                    title: "로그아웃",
                    backgroundColor: .brandPoint,
                    action: logoutAction
                )
            }
        }
        .padding()
        .background(.customWhite)
        .cornerRadius(16, corners: .allCorners)
        .shadow(radius: 10)
    }
}
