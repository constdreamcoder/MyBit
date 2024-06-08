//
//  FavoriteView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct FavoriteView: View {
    
    @StateObject private var intent = FavoriteIntent()
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        CustomNavigationView(title: "Favorite Coin") {
            // TODO: - showsIndicators iOS 16 대응
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(intent.state.coinMarkets, id: \.id) { coinMarket in
                        MyFavoriteCell(market: coinMarket, bottomStackAlignment: .trailing)
                            .padding()
                            .background(.customWhite)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 16)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            intent.send(.getFavorites)
        }
    }
}

#Preview {
    FavoriteView()
}
