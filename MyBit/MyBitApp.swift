//
//  MyBitApp.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import Combine

@main
struct MyBitApp: App {
    
    @StateObject private var appIntent = AppIntent()
    @StateObject private var network = Network()
    
    init() {
        KakaoSDK.initSDK(appKey: APIKeys.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if network.isConnected {
                    LaunchScreenView()
                        .onOpenURL(perform: { url in
                            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                                let _ = AuthController.handleOpenUrl(url: url)
                            }
                        })
                        .onAppear {
                            appIntent.send(.isLogin)
                        }
                        .environmentObject(appIntent)
                } else {
                    NetworkMonitorView(isConnected: network.isConnected)
                }
            }
            .onAppear {
                // 뷰가 나타날 때 network 체크
                network.checkConnection()
            }
        }
    }
}
