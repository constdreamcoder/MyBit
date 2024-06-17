//
//  TrendingView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import SwiftUI

struct TrendingView: View {
    
    @StateObject private var intent = TrendingIntent()
    @Binding var profileImage: String
    
    var body: some View {
        CustomNavigationView(title: "Crypto Coin", profileImage: $profileImage) {
            List {
                if intent.state.coinMarkets.count >= 2 {
                    Section {
                        ScrollView(.horizontal, showsIndicators: false)  {
                            HStack(spacing: 16) {
                                ForEach(intent.state.coinMarkets, id: \.id) { coinMarket in
                                    NavigationLink(destination: DetailView(id: coinMarket.id)) {
                                        MyFavoriteCell(market: coinMarket, bottomStackAlignment: .leading)
                                            .frame(width: 200, height: 130, alignment: .leading)
                                            .padding()
                                            .background(.customLightGray)
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    }
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
                }
                
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(intent.state.trendingCoins, id: \.[0].index) { trendingCoinChunk in
                                VStack {
                                    ForEach(trendingCoinChunk, id: \.coin.id) { trendingCoin in
                                        NavigationLink(destination: DetailView(id: trendingCoin.coin.id)) {
                                            TopRankCell(trendingType: .coin(trendingCoin))
                                        }
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
                        HStack(alignment: .top) {
                            ForEach(intent.state.trendingNFTs, id: \.[0].index) { trendingNFTChunk in
                                VStack {
                                    ForEach(trendingNFTChunk, id: \.nft.id) { trendingNFT in
                                        TopRankCell(trendingType: .nft(trendingNFT))
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
                intent.send(.getFavorites)
                intent.send(.getTrending)
            }
        }
    }
}

#Preview {
    TrendingView(profileImage: .constant(""))
}

struct MyFavoriteCell: View {
    
    let market: Market
    let bottomStackAlignment: HorizontalAlignment
    
    var body: some View {
        VStack(alignment: .leading) {            
            ItemInfoView(item: market)
            
            Spacer()
            
            VStack(alignment: bottomStackAlignment, spacing: 4) {
                Text("₩\(market.current_price, specifier: "%.0f")")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundStyle(.customBlack)
                    .lineLimit(1)
                Text("\(market.price_change_percentage_24h, specifier: "%.2f")%")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(market.price_change_percentage_24h > 0 ? .customRed : .customBlue)
                    .lineLimit(1)
                    .padding(8)
                    .background(market.price_change_percentage_24h > 0 ? .customLightRed : .customSkyBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }
}

struct TopRankCell: View {
    
    let trendingType: TrendingRankingType
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text("\(trendingType.index + 1)")
                        .font(.system(size: 28))
                        .fontWeight(.semibold)
                        .foregroundStyle(.customDarkGray)
                        .frame(minWidth: 32)
                    
                    ItemInfoView(item: trendingType.item)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    switch trendingType {
                    case .coin(let trendingCoinType):
                        Text("$\(trendingCoinType.coin.data?.price ?? 0, specifier: "%.4f")")
                            .font(.system(size: 18))
                            .foregroundStyle(.customBlack)
                        Text("\(trendingCoinType.coin.data?.price_change_percentage_24h.krw ?? 0, specifier: "%.2f")%")
                            .foregroundStyle(trendingCoinType.coin.data?.price_change_percentage_24h.krw.changeRateColor ?? .customBlack)
                            .font(.system(size: 14))
                    case .nft(let trendingNFTType):
                        Text("$\(trendingNFTType.nft.data.floor_price)")
                            .font(.system(size: 18))
                            .foregroundStyle(.customBlack)
                        Text("\(Double(trendingNFTType.nft.data.floor_price_in_usd_24h_percentage_change) ?? 0, specifier: "%.2f")%")
                            .foregroundStyle(Double(trendingNFTType.nft.data.floor_price_in_usd_24h_percentage_change)?.changeRateColor ?? .customBlack)
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.vertical, 8)
            
            Divider()
        }
        .frame(width: 300, height: 60, alignment: .leading)
        .padding(.top, 8)
    }
}
