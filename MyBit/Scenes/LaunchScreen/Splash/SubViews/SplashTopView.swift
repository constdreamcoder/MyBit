//
//  SplashTopView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct SplashTopView: View {
    var body: some View {

        Text("MyBit")
            .font(.system(size: 50, weight: .bold))
            .padding(.bottom, 12)
        
        Text("쉽고 간편한 코인 거래")
            .font(.system(size: 22, weight: .bold))
            .padding(.bottom, 30)
        
        Image(.cryptocurrencies)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .padding(16)
    }
}

#Preview {
    SplashTopView()
}
