//
//  DetailView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI
import DGCharts
import Kingfisher

struct DetailView: View {
    
    let id: String
    @StateObject var intent = DetailIntent()
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    init(id: String) {
        self.id = id
    }
    
    var body: some View {
        VStack {
            DetailTopView(topViewDatas: intent.state.topViewDatas)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(intent.state.middleViewData, id: \.title) { item in
                    DetailMiddleElementView(detailMiddleItem: item)
                }
            }
            
            ChartView(entries: intent.state.chartDataEntries)
            
            HStack {
                Spacer()
                
                Text("\(intent.state.lastUpdatedDate.convertToLastUpdatedFormat) 업데이트")
                    .foregroundStyle(.customGray)
            }
            .padding()
            
            Spacer()
        }
        .toolbar {
            FavoriteStarView(isFavorite: intent.state.isFavorite)
                .onTapGesture {
                    intent.send(.favoriteButtonTap)
                }
        }
        .navigationBarTitle("", displayMode: .inline) // TODO: - 추후 사라지니 대응
        .onAppear {
            intent.send(.getCoinMarkets(idList: [id]))
        }
    }
}

#Preview {
    DetailView(id: "bitcoin")
}

struct DetailTopView: View {
    
    let topViewDatas: TopViewData?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    KFImage(URL(string: topViewDatas != nil ? topViewDatas?.image ?? "" : ""))
                        .placeholder {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.customGray)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                    
                    Text(topViewDatas != nil ? topViewDatas?.name ?? "" : "Solena")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading) {
                    Text("₩\(topViewDatas != nil ? topViewDatas?.currentPrice ?? 0 : 69234245, specifier: "%.0f")")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("\(topViewDatas != nil ? topViewDatas?.priceChangePercentage24h ?? 0: 0, specifier: "%.2f")%")
                            .foregroundStyle(topViewDatas?.priceChangePercentage24h ?? 0 >= 0 ? .customRed : .customBlue)
                            .font(.system(size: 24))
                        Text("Today")
                            .foregroundStyle(.customGray)
                            .font(.system(size: 24))
                    }
                }
                
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct DetailMiddleElementView: View {
    
    let detailMiddleItem: DetailMiddleItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(detailMiddleItem.title)
                .fontWeight(.semibold)
                .foregroundStyle(detailMiddleItem.titleColor)
            Text("₩\(detailMiddleItem.price, specifier: "%.0f")")
                .foregroundStyle(.customDarkGray)
        }
        .font(.system(size: 24))
    }
}
