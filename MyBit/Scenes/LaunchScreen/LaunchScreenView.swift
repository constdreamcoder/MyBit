//
//  LaunchScreenView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @State private var isLaunching: Bool = true
    
    var body: some View {
        if isLaunching {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLaunching = false
                    }
                }
        } else {
            ContentView()
        }
    }
}

#Preview {
    LaunchScreenView()
}
