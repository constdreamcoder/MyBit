//
//  DetailView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var intent = DetailIntent()

    var body: some View {
        Text("Hello, DetailView!")
            .onAppear {
                intent.send(.getCoinMarkets(idList: ["bitcoin", "wrapped-bitcoin"]))
            }
    }
}

#Preview {
    DetailView()
}
