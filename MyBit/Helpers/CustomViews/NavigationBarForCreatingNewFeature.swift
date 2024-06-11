//
//  NavigationBarForCreatingNewFeature.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/11/24.
//

import SwiftUI

struct NavigationBarForCreatingNewFeature: View {
    
    let title: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 15) {
                    BottomViewGrabber()
                        .padding(.top, 6)
                    
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                }
                
                VStack(spacing: 15) {
                    BottomViewGrabber()
                        .padding(.top, 4)
                        .hidden()
                    
                    HStack {
                        Button {
                            print("dismiss")
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .foregroundStyle(.customBlack)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 2)
                        
                        Spacer()
                    }
                }
            }
            
            Divider()
        }
        .background(.customWhite)
    }
}
