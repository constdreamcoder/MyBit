//
//  MyBitTabView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct MyBitTabView: View {
    var body: some View {
        TabView {
            TrendingView()
                .tabItem {
                    Label("", systemImage: "chart.line.uptrend.xyaxis")
                }
            SearchView()
                .tabItem {
                    Label("", systemImage: "magnifyingglass")
                }
            FavoriteView()
                .tabItem {
                    Label("", systemImage: "bag")
                }
            ProfileView()
                .tabItem {
                    Label("", systemImage: "person")
                }
        }
        .tint(.brandPoint)
    }
}

#Preview {
    MyBitTabView()
}
