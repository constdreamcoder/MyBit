//
//  ExchangeView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import SwiftUI

struct ExchangeView: View {
    
    @StateObject var intent = ExchangeIntent()
    
    var body: some View {
        CustomNavigationView(title: "Exchange") {
            VStack {
                BitcoinFieldView()
                
                List(intent.state.currentPriceList, id: \.id) { currentPrice in
                    BitcoinCell(currentPrice: currentPrice)
                }
                .listStyle(.plain)
            }
        }
        .task {
            intent.send(.getCurrentPrices)
        }
        .onDisappear {
            WebSocketManager.shared.closeWebSocket()
        }
    }
}

#Preview {
    ExchangeView()
}

struct BitcoinFieldView: View {
    var body: some View {
        HStack {
            Text("한글명")
                .frame(minWidth: 100, alignment: .leading)
            
            Text("현재가")
                .frame(minWidth: 80, alignment: .trailing)
            
            Text("전일대비")
                .frame(minWidth: 70, alignment: .trailing)
            
            Text("거래대금")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .foregroundStyle(.customGray)
        .font(.system(size: 16.0))
        .padding(.horizontal)
    }
}

struct BitcoinCell: View {
    
    let currentPrice: CurrentPrice
    
    init(currentPrice: CurrentPrice) {
        self.currentPrice = currentPrice
    }
    
    var body: some View {
        HStack {
            Text(currentPrice.market)
                .font(.system(size: 14.0))
                .frame(minWidth: 100, alignment: .leading)
            
            BitcoinInfoStackView(
                topText: currentPrice.tradePrice.currencyFormat
            )
            .bitcoinChangeColor(currentPrice.change)
            .frame(minWidth: 80, alignment: .trailing)
            
            BitcoinInfoStackView(
                topText: currentPrice.signedChangeRate.percentFormat,
                bottomText: currentPrice.signedChangePrice.currencyFormat
            )
            .bitcoinChangeColor(currentPrice.change)
            .frame(minWidth: 70, alignment: .trailing)
            
            BitcoinInfoStackView(
                topText: "\(currentPrice.accTradePrice24H.transactionPrice24HFormat)백만"
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct BitcoinInfoStackView: View {
    
    let topText: String
    let bottomText: String
    let alignment: HorizontalAlignment
    
    init(
        topText: String = "",
        bottomText: String = "",
        alignment: HorizontalAlignment = .trailing
    ) {
        self.topText = topText
        self.bottomText = bottomText
        self.alignment = alignment
    }
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(topText)
                .font(.system(size: 14.0))
            Text(bottomText)
                .font(.system(size: 10.0))
        }
    }
}

#Preview {
    ExchangeView()
}

