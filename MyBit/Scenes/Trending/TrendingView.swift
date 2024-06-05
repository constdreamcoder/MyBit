//
//  TrendingView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import SwiftUI

struct TrendingView: View {
    
    @StateObject private var intent = TrendingIntent()
    
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                intent.send(.getTrending)
            }
    }
}

#Preview {
    TrendingView()
}
