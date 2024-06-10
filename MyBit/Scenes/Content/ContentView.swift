//
//  ContentView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isFirstLaunching") var isFirstLaunching: Bool = true

    var body: some View {
        MyBitTabView()
            .fullScreenCover(isPresented: $isFirstLaunching) {
                OnboardingView(isFirstLaunching: $isFirstLaunching)
            }
    }
}

#Preview {
    ContentView()
}
