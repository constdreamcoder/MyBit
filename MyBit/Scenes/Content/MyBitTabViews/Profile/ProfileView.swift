//
//  ProfileView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        CustomNavigationView(title: "Profile", isProfile: true) {
            VStack {
                ProfilePhotoView()
                
                if #available(iOS 16.0, *) {
                    List {
                        Section {
                            ProfileCell(title: "닉네임", data: "옹골찬 고래밥")
                            ProfileCell(title: "연락처", data: "010-1234-1234")
                        }
                        
                        Section {
                            ProfileCell(title: "이메일", data: "sesac@sesac.com")
                            ProfileCell(title: "연결된 소설 계정", data: "")
                            ProfileCell(title: "로그아웃", data: "")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(.customLightGray)
                } else {
                    // TODO: - iOS15 version 대응
                }
            }
            .background(.customLightGray)
        }
    }
}

#Preview {
    ProfileView()
}

struct ProfilePhotoView: View {
    var body: some View {
        Image(systemName: "person.crop.circle")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 70)
    }
}

struct ProfileCell: View {
    let title: String
    let data: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .bold))
            
            Spacer()
            
            Text(data)
                .foregroundStyle(.customDarkGray)
                .font(.system(size: 13))
        }
        .listRowSeparator(.hidden)
    }
}
