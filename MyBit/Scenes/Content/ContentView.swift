//
//  ContentView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isOnOnBoarding") var isOnOnBoarding: Bool = true

    var body: some View {
        MyBitTabView()
            .fullScreenCover(isPresented: $isOnOnBoarding) {
                OnboardingView(isOnOnBoarding: $isOnOnBoarding)
            }
    }
}

#Preview {
    ContentView()
}
