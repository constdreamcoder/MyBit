//
//  CustomButton.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct CustomButton<Content>: View where Content: View {
    
    private let action: () -> Void
    private let label: Content
    
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Content) {
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        Button(action: action, label: {
            label
                .foregroundStyle(.customWhite)
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: 44)
        })
    }
}

#Preview {
    CustomButton(action: {print("시작!")}, label: {
        Text("시작하기")
    })
}
