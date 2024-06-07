//
//  DetailView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI
import DGCharts

struct DetailMiddleItem {
    let title: String
    let price: Int
    let titleColor: Color
}

struct DetailView: View {
    
    @StateObject private var intent = DetailIntent()
    
    let data: [DetailMiddleItem] = [
        DetailMiddleItem(title: "고가", price: 69234243, titleColor: .customRed),
        DetailMiddleItem(title: "저가", price: 69234243, titleColor: .customBlue),
        DetailMiddleItem(title: "신고점", price: 69234243, titleColor: .customRed),
        DetailMiddleItem(title: "신저점", price: 69234243, titleColor: .customBlue)
    ]
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack {
                DetailTopView()

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(data, id: \.title) { item in
                        DetailMiddleElementView(detailMiddleItem: item)
                    }
                }
                
                ChartView(entry: [
                    ChartDataEntry(x: 0, y: 3234.234234),
                    ChartDataEntry(x: 1, y: 3444.234234),
                    ChartDataEntry(x: 2, y: 23453.3245),
                    ChartDataEntry(x: 3, y: 324234.234234),
                    ChartDataEntry(x: 4, y: 324234.234234),
                ])
                
                HStack {
                    Spacer()
                    
                    Text("2/21 11:53:50 업데이트")
                        .foregroundStyle(.customGray)
                }
                .padding()
               
                
                Spacer()
            }
            .toolbar {
                FavoriteStarView()
            }
        }
        .onAppear {
            intent.send(.getCoinMarkets(idList: ["bitcoin", "wrapped-bitcoin"]))
        }
    }
}

#Preview {
    DetailView()
}

struct DetailTopView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                    
                    Text("Solana")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading) {
                    Text("₩69,234,245")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("+3.22%")
                            .foregroundStyle(.customRed)
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
            Text("₩\(detailMiddleItem.price)")
                .foregroundStyle(.customDarkGray)
        }
        .font(.system(size: 24))
    }
}
