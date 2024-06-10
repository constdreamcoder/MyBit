//
//  BottomButtonModifier.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct BottomButtonModifier: ViewModifier {
    
    let color: Color
        
    func body(content: Content) -> some View {
        content
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 16)
    }
}

extension View {
    func bottomButtonShape(_ color: Color) -> some View {
        modifier(BottomButtonModifier(color: color))
    }
}

