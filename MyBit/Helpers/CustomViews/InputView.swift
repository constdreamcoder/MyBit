//
//  InputView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct InputView: View {
    
    let title: String
    let placeholder: String
    let inputText: String
    @ObservedObject var intent: SignUpIntent
    let showRightButton: Bool
    let isSecure: Bool
    
    init(
        title: String,
        placeholder: String,
        inputText: String,
        intent: SignUpIntent,
        showRightButton: Bool = false,
        isSecure: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self.inputText = inputText
        self.showRightButton = showRightButton
        self.isSecure = isSecure
        self.intent = intent
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
            
            HStack {
                if isSecure {
                    SecureField(
                        placeholder,
                        text: Binding(
                            get: { inputText },
                            set: { newValue in
                                
                            }
                        )
                    )
                    .font(.system(size: 13, weight: .bold))
                    .disableAutocorrection(true)
                    .padding(.vertical, 14)
                    .padding(.leading, 12)
                    .padding(.trailing, showRightButton ? 0 : 12)
                    .background(.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    TextField(
                        placeholder,
                        text: Binding(
                            get: {inputText},
                            set: { newValue in
                                
                            }
                        )
                    )
                    .font(.system(size: 13, weight: .bold))
                    .disableAutocorrection(true)
                    .padding(.vertical, 14)
                    .padding(.leading, 12)
                    .padding(.trailing, showRightButton ? 0 : 12)
                    .background(.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                if showRightButton {
                    CustomButton(action: {
                        print("액션가면")
                    }, label: {
                        Text("중복 확인")
                    })
                    .bottomButtonShape(.brandPoint)
                    .frame(width: 120, height: 45)
                }
            }
        }
        .background(.clear)
        .padding(.leading, 16)
        .padding(.trailing, showRightButton ? 0 : 16)
    }
}
