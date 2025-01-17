//
//  ContentView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var appIntent: AppIntent
    
    @AppStorage("isOnBoardingPresented") var isOnBoardingPresented: Bool = true
  
    @KeychainStorage(.profileImage) private var profileImage: String = ""
    @KeychainStorage(.accessToken) private var accessToken: String = ""
    @KeychainStorage(.refreshToken) private var refreshToken: String = ""

    var body: some View {
        MyBitTabView(profileImage: $profileImage)
            .overlay {
                if appIntent.state.showLogutAlert {
                    LogoutAlertView(
                        cancelAction: {
                            appIntent.send(.dismissLogoutAlert)
                        },
                        logoutAction: {
                            appIntent.send(.logout)
                        }
                    )
                }
            }
            .fullScreenCover(isPresented: $isOnBoardingPresented) {
                OnboardingView(isOnBoardingPresented: $isOnBoardingPresented, profileImage: $profileImage)
            }
            .onAppear {
                print("처음 profileImage", profileImage)
                print("accessToken", accessToken)
                print("refreshToken", refreshToken)
            }
            .onReceive(Just(appIntent.state.isLogin), perform: { isLogin in
                isOnBoardingPresented = !isLogin
            })
    }
}

#Preview {
    ContentView()
}
