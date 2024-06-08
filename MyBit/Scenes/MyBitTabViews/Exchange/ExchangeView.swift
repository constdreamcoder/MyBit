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
        VStack {
            List(intent.state.currentPriceList, id: \.id) { currentPrice in
                BitcoinCell(currentPrice: currentPrice)
            }
            .listStyle(.plain)

            Button(action: {
                WebSocketManager.shared.closeWebSocket()
            }, label: {
                Text("소켓 닫기")
            })
        }
        .task {
            intent.send(.getCurrentPrices)
        }
    }
}

#Preview {
    ExchangeView()
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
            
            Spacer()
   

            BitcoinInfoStackView(
                topText: currentPrice.tradePrice.currencyFormat
            )
            
            Spacer()
            
            BitcoinInfoStackView(
                topText: currentPrice.signedChangeRate.percentFormat,
                bottomText: currentPrice.signedChangePrice.currencyFormat
            )
            
            Spacer()

            BitcoinInfoStackView(
                topText: "\(currentPrice.accTradePrice24H.transactionPrice24HFormat)백만"
            )
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

