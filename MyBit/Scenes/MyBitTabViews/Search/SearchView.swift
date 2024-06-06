//
//  SearchView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI
import Kingfisher

struct SearchView: View {
    
    @StateObject private var intent = SearchIntent()
    @State private var searchQueryString: String = ""
    
    var body: some View {
        CustomNavigationView {
            List(intent.state.searchedCoins) { coin in
                HStack {
                    ItemInfoView(coin: coin)
                    
                    Spacer()
                    
                    Image("btn_star")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
                .listRowSeparator(.hidden)
            }
        }
        .searchable(
            text: $searchQueryString,
            placement: .navigationBarDrawer,
            prompt: "코인명을 검색해주세요"
        )
        .onSubmit(of: .search) {
            intent.send(.searchCoins(query: searchQueryString))
        }
    }
}

#Preview {
    SearchView()
}

struct ItemInfoView: View {
    
    let coin: Coin
    
    var body: some View {
        HStack {
            KFImage(URL(string: coin.thumb))
                .placeholder {
                    Circle()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.customGray)
                }
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundStyle(.customBlack)
                Text(coin.symbol)
                    .font(.system(size: 16))
                    .lineLimit(1)
                    .foregroundStyle(.customGray)
            }
        }
    }
}

struct ProfileImage: View {
    var body: some View {
        Image(systemName: "person.crop.circle")
            .resizable()
            .frame(width: 36, height: 36)
            .overlay(Circle().stroke(.brandPoint, lineWidth: 3.0))
    }
}
