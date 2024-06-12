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
    
    var body: some View {
        CustomNavigationView(title: "Search") {
            List(intent.state.searchedCoins, id: \.coin.id) { searchedCoin in
                NavigationLink(destination: DetailView(id: searchedCoin.coin.id)) {
                    HStack {
                        ItemInfoView(item: searchedCoin.coin)
                        
                        Spacer()
                        
                        FavoriteStarView(isFavorite: searchedCoin.isFavorite)
                            .onTapGesture {
                                intent.send(.favoriteButtonTap(tappedCoin: searchedCoin))
                            }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .onAppear {
                intent.send(.refresh)
            }
        }
        .searchable(
            text: Binding(
                get: { intent.state.searchQueryString },
                set: { intent.send(.inputSearchQueryString(query: $0)) }
            ),
            placement: .navigationBarDrawer,
            prompt: "코인명을 검색해주세요"
        )
        .onSubmit(of: .search) {
            intent.send(.searchCoins)
        }
    }
}

#Preview {
    SearchView()
}

struct ItemInfoView: View {
    
    let item: ItemEssentialElements
    
    var body: some View {
        HStack {
            KFImage(URL(string: item.thumb))
                .placeholder {
                    Circle()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.customGray)
                }
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundStyle(.customBlack)
                Text(item.symbol)
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
