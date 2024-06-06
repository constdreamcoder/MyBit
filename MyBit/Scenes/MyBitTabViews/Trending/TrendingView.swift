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
        CustomNavigationView(title: "Crypto Coin") {
            List {
                Section {
                    ScrollView(.horizontal, showsIndicators: false)  {
                        HStack(spacing: 16) {
                            ForEach(0..<10) { index in
                                MyFavoriteCell()
                            }
                        }
                    }
                } header: {
                    Text("MyFavorite")
                        .bold()
                        .font(.title)
                        .foregroundStyle(.customBlack)
                }
                .listSectionSeparator(.hidden)
                
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<10) { _ in
                                VStack {
                                    ForEach(0..<3) { index in
                                        TopRankCell()
                                    }
                                }
                                .padding(.leading, 16)
                            }
                        }
                    }
                } header: {
                    Text("Top 15 Coin")
                        .bold()
                        .font(.title)
                        .foregroundStyle(.customBlack)
                }
                .listSectionSeparator(.hidden)
                
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<10) { _ in
                                VStack {
                                    ForEach(0..<3) { index in
                                        TopRankCell()
                                    }
                                }
                                .padding(.leading, 16)
                            }
                            
                        }
                    }
                } header: {
                    Text("Top 7 NFT")
                        .bold()
                        .font(.title)
                        .foregroundStyle(.customBlack)
                }
                .listSectionSeparator(.hidden)
                
            }
            .onAppear {
                intent.send(.getTrending)
            }
        }
    }
}

#Preview {
    TrendingView()
}


struct CoinInfoView: View {
        
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

struct MyFavoriteCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            CoinInfoView()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("₩69,345,234")
                    .font(.system(size: 20))
                    .bold()
                    .lineLimit(1)
                Text("+0.64%")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.customRed)
                    .lineLimit(1)
            }
        }
        .frame(width: 200, height: 130, alignment: .leading)
        .padding()
        .background(.customLightGray)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct TopRankCell: View {
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 12) {
                    Text("12")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.customDarkGray)
                    
                    CoinInfoView()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$0.4173")
                        .font(.system(size: 18))
                    Text("+21.41%")
                        .foregroundStyle(.customRed)
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 8)
            
            Divider()
        }
        .frame(width: 300, height: 60, alignment: .leading)
        .padding(.top, 8)
    }
}
