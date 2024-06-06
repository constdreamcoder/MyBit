//
//  SearchView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var intent = SearchIntent()
    @State private var searchQueryString: String = ""
    
    var body: some View {
        NavigationView {
            List(1..<20) { ocean in
                HStack {
                    ItemInfoView()
                    
                    Spacer()
                    
                    Image("btn_star")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Search")
            .listStyle(.plain)
            .toolbar  {
                ProfileImage()
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
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Bitcoin")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundStyle(.customBlack)
                Text("BTC")
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
