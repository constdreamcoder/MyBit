//
//  FavoriteStarView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import SwiftUI

struct FavoriteStarView: View {
    
    let isFavorite: Bool
    
    var body: some View {
        Image(isFavorite ? "btn_star_fill" : "btn_star")
            .resizable()
            .frame(width: 28, height: 28)
    }
}

#Preview {
    FavoriteStarView(isFavorite: false)
}
