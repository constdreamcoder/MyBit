//
//  EditProfileView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import SwiftUI
import Combine

struct EditProfileView: View {
    
    @StateObject private var intent = EditProfileIntent()
    
    let navigationTitle: String
    let placeholder: String
    let previousInput: String
    let inputType: EditProfileInputType
    
    @Binding var selection: String?
    
    var body: some View {
        
        VStack {
            InputView(
                title: "",
                placeholder: placeholder,
                textFieldGetter: { intent.state.input },
                textFieldSetter: {
                    if previousInput != $0 { intent.send(.write(input: $0,inputType: inputType)) }
                },
                secureFieldGetter: { "" },
                secureFieldSetter: { _ in },
                rightButtonAction: { }
            )
            .keyboardType( inputType == .phone ? .phonePad : .default)
            .onAppear {
                if intent.state.initialFlage {
                    intent.send(.initialize(previousInput: previousInput))
                }
            }
            .onReceive(Just(intent.state.input)) { newValue in
                
                guard inputType == .phone, previousInput != newValue else { return }
                
                let filtered = newValue.filter { "0123456789-".contains($0) }
                if filtered != newValue {
                    intent.send(.writeInput(input: filtered))
                }
            }
            
            Spacer()
            
            CustomButton {
                print("호잇")
                intent.send(.editMyProfile(inputType: inputType))
            } label: {
                Text("완료")
            }
            .bottomButtonShape(intent.state.validation ? .brandPoint : .customGray)
            .padding(.bottom, 12)
            .disabled(!intent.state.validation)
        }
        .background(.customLightGray)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(Just(intent.state.myProfile)) { newMyProfile in
            if newMyProfile != nil { selection = nil }
        }
    }
}

#Preview {
    EditProfileView(navigationTitle: "타이틀", placeholder: "타이틀을 입력해주세요.", previousInput: "안녕", inputType: .nickname, selection: .constant(nil))
}
