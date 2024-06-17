//
//  MyBitTabView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct MyBitTabView: View {
    
    @Binding var profileImage: String?
    
    var body: some View {
        TabView {
            TrendingView(profileImage: $profileImage)
                .tabItem {
                    Label("", systemImage: "chart.line.uptrend.xyaxis")
                }
            SearchView(profileImage: $profileImage)
                .tabItem {
                    Label("", systemImage: "magnifyingglass")
                }
            ExchangeView(profileImage: $profileImage)
                .tabItem {
                    Label("", systemImage: "doc.plaintext")
                }
            FavoriteView(profileImage: $profileImage)
                .tabItem {
                    Label("", systemImage: "bag")
                }
            ProfileView(profileImage: $profileImage)
                .tabItem {
                    Label("", systemImage: "person")
                }
        }
        .tint(.brandPoint)
    }
}

#Preview {
    MyBitTabView(profileImage: .constant(""))
}
