//
//  FavoriteView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct FavoriteView: View {
    
    @StateObject private var intent = FavoriteIntent()
    @Binding var profileImage: String
    
    let columns = [
        GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        CustomNavigationView(title: "Favorite Coin", profileImage: $profileImage) {
            // TODO: - showsIndicators iOS 16 대응
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(intent.state.coinMarkets, id: \.id) { coinMarket in
                        NavigationLink(destination: DetailView(id: coinMarket.id)) {
                            MyFavoriteCell(market: coinMarket, isFavoriteView: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                                .background(.customWhite)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(radius: 16)
                        }
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
    FavoriteView(profileImage: .constant(""))
}
