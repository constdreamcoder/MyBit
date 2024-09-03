//
//  NetworkMonitor.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/25/24.
//

import SwiftUI
import Network

final class Network: ObservableObject {
    
    // NWPathMonitor 클래스 인스턴스 선언
    let monitor = NWPathMonitor()
    // 네트워크 모니터링 담당 Thread
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var isConnected: Bool = false
    
    func checkConnection() {
        // 모니터링 시작
        monitor.start(queue: queue)
        // 네트워크 연결 상태 모니터링 결과 반환
        monitor.pathUpdateHandler = { path in
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                // 네트워크가 연결되어있다면 isConnected에 true 값 전달
                isConnected = path.status == .satisfied
            }
        }
    }
    
    func stop() {
        // 모니터링 취소
        monitor.cancel()
    }
}
