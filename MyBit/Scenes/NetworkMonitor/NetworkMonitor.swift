//
//  NetworkMonitor.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/25/24.
//

import SwiftUI
import Network

final class Network: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var isConnected: Bool = false
    
    func checkConnection() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                // 네트워크가 연결되어있다면 connected에 true 값 전달
                self?.isConnected = path.status == .satisfied
            }
        }
    }
    
    func stop() {
        monitor.cancel()
    }
}
