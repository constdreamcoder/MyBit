//
//  ProfileView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var intent = ProfileIntent()
    
    var body: some View {
        CustomNavigationView(title: "Profile", isProfile: true) {
            VStack {
                ProfilePhotoView()
                
                if #available(iOS 16.0, *) {
                    List {
                        Section {
                            NavigationLink(destination: EditProfileView(navigationTitle: "닉네임", placeholder: "닉네임을 입력하세요")) {
                                ProfileCell(title: "닉네임", data: intent.state.myProfile?.nickname)
                            }
                            NavigationLink(destination: EditProfileView(navigationTitle: "연락처", placeholder: "연락처를 입력하세요")) {
                                ProfileCell(title: "연락처", data: intent.state.myProfile?.phone)
                            }
                        }
                        
                        Section {
                            ProfileCell(title: "이메일", data: intent.state.myProfile?.email)
                            ProfileCell(title: "연결된 소설 계정", socialLoginImage: intent.state.myProfile?.provider?.image)
                            ProfileCell(title: "로그아웃")
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
            .onAppear {
                intent.send(.fetchMyProfile)
            }
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
    let data: String?
    let socialLoginImage: String?
    
    init(title: String, data: String? = nil, socialLoginImage: String? = nil) {
        self.title = title
        self.data = data
        self.socialLoginImage = socialLoginImage
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .bold))
            
            Spacer()
            
            if let socialLoginImage = socialLoginImage,
                !socialLoginImage.isEmpty && (data == nil || data == "") {
                Image(socialLoginImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 20)
            } else {
                Text(data ?? "")
                    .foregroundStyle(.customDarkGray)
                    .font(.system(size: 13))
            }
    
        }
        .listRowSeparator(.hidden)
    }
}
