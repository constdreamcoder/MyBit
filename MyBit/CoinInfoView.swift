//
//  CoinInfoView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import SwiftUI

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

#Preview {
    CoinInfoView()
}
