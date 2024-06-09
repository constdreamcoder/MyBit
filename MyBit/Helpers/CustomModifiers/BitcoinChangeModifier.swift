//
//  BitcoinChangeModifier.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/9/24.
//

import SwiftUI

struct BitcoinChangeModifier: ViewModifier {
    
    let change: CurrentPrice.Change
    
    func body(content: Content) -> some View {
        if change == .rise {
            content
                .foregroundStyle(.customRed)
        } else if change == .fall {
            content
                .foregroundStyle(.customBlue)
        } else {
            content
                .foregroundStyle(.customBlack)
        }
    }
}

extension View {
    func bitcoinChangeColor(_ change: CurrentPrice.Change = .even) -> some View {
        modifier(BitcoinChangeModifier(change: change))
    }
}
