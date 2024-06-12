//
//  ContentView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isOnBoardingPresented") var isOnBoardingPresented: Bool = true

    var body: some View {
        MyBitTabView()
            .fullScreenCover(isPresented: $isOnBoardingPresented) {
                OnboardingView(isOnBoardingPresented: $isOnBoardingPresented)
            }
    }
}

#Preview {
    ContentView()
}
