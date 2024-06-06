//
//  SearchView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var intent = SearchIntent()
    
    var body: some View {
        Text("Hello, SearchView!")
            .onAppear {
                intent.send(.searchCoins(query: "bitcoin"))
            }
    }
}

#Preview {
    SearchView()
}
