//
//  EditProfileView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import SwiftUI

struct EditProfileView: View {
    let navigationTitle: String
    let placeholder: String
    
    var body: some View {
        
        VStack {
            InputView(
                title: "",
                placeholder: placeholder,
                textFieldGetter: { "" },
                textFieldSetter: { _ in },
                secureFieldGetter: { "" },
                secureFieldSetter: { _ in },
                rightButtonAction: { }
            )
            
            Spacer()
            
            CustomButton {
                print("호잇")
            } label: {
                Text("완료")
            }
            .bottomButtonShape(.brandPoint)
            .padding(.bottom, 12)
        }
        .background(.customLightGray)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EditProfileView(navigationTitle: "타이틀", placeholder: "타이틀을 입력해주세요.")
}
