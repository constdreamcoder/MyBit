//
//  ContentView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @AppStorage("isOnBoardingPresented") var isOnBoardingPresented: Bool = true
    
    @KeychainStorage(.profileImage) private var profileImage: String = ""
    @KeychainStorage(.accessToken) private var accessToken: String = ""
    @KeychainStorage(.refreshToken) private var refreshToken: String = ""

    var body: some View {
        MyBitTabView(profileImage: $profileImage)
            .fullScreenCover(isPresented: $isOnBoardingPresented) {
                OnboardingView(isOnBoardingPresented: $isOnBoardingPresented, profileImage: $profileImage)
            }
            .onAppear {
                print("처음 profileImage", profileImage)
                print("accessToken", accessToken)
                print("refreshToken", refreshToken)
            }
    }
}

#Preview {
    ContentView()
}
