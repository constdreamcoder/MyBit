//
//  InputView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/10/24.
//

import SwiftUI

struct InputView: View {
    
   private let title: String
   private let placeholder: String
   private let showRightButton: Bool
   private let isSecure: Bool
   private let textFieldGetter: () -> String
   private let textFieldSetter: (String) -> Void
   private let secureFieldGetter: () -> String
   private let secureFieldSetter: (String) -> Void
    
    init(
        title: String,
        placeholder: String,
        showRightButton: Bool = false,
        isSecure: Bool = false,
        textFieldGetter: @escaping (() -> String),
        textFieldSetter: @escaping (String) -> Void,
        secureFieldGetter: @escaping () -> String,
        secureFieldSetter: @escaping (String) -> Void
    ) {
        self.title = title
        self.placeholder = placeholder
        self.showRightButton = showRightButton
        self.isSecure = isSecure
        self.textFieldGetter = textFieldGetter
        self.textFieldSetter = textFieldSetter
        self.secureFieldGetter = secureFieldGetter
        self.secureFieldSetter = secureFieldSetter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
            
            HStack {
                
                Group {
                    if isSecure {
                        SecureField(
                            placeholder,
                            text: Binding(get: secureFieldGetter, set: secureFieldSetter)
                        )
                    } else {
                        TextField(
                            placeholder,
                            text: Binding(get: textFieldGetter, set: textFieldSetter)
                        )
                       
                    }
                }
                .font(.system(size: 13, weight: .bold))
                .disableAutocorrection(true)
                .padding(.vertical, 14)
                .padding(.leading, 12)
                .padding(.trailing, showRightButton ? 0 : 12)
                .background(.customWhite)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
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
