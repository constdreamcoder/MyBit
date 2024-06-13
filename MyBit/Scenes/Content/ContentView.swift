//
//  ContentView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isOnBoardingPresented") var isOnBoardingPresented: Bool = true
    @KeychainStorage(key: .accessToken) private var accessToken: String?
    @KeychainStorage(key: .refreshToken) private var refreshToken: String?

    var body: some View {
        MyBitTabView()
            .fullScreenCover(isPresented: $isOnBoardingPresented) {
                OnboardingView(isOnBoardingPresented: $isOnBoardingPresented)
            }
            .onAppear {
                print("accessToken", accessToken)
                print("refreshToken", refreshToken)
            }
    }
}

#Preview {
    ContentView()
}
