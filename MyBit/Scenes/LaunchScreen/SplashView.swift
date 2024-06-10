//
//  SplashView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.customLightGray
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 60)

                SplashTopView()
                
                Spacer()
            }
        }
    }
}

#Preview {
    SplashView()
}
