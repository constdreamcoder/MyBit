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
            .onReceive(Just(network.isConnected)) {
                //TODO: onChange를 통하여 toast message를 띄울 수 도 있음
                if !$0 {
                    //TODO: Toast 팝업 - 네트워크 연결에 실패했습니다.
                }
            }
        }
    }
}
