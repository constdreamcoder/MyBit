//
//  NetworkMonitorView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/25/24.
//

import SwiftUI

struct NetworkMonitorView: View {
    var isConnected: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Internet status:")
                .font(.title)
            
            Image(systemName: isConnected ? "wifi" : "wifi.slash")
                .font(.title)
                .foregroundStyle(isConnected ? .green : .red)
            
            Text(isConnected ? "Connected" : "Disconnected")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(isConnected ? .green : .red)
        }
    }
}

#Preview {
    NetworkMonitorView(isConnected: true)
}
