//
//  WebSocketManager.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation
import Combine

final class WebSocketManager: NSObject {
    static let shared = WebSocketManager()
    
    private var websocket: URLSessionWebSocketTask?
    private var isOpen = false
    
    private var timer: Timer?
    
    var tickerSbj = PassthroughSubject<Ticker, Never>()
    
    private override init() {}
    
    func openWebSocket() {
        if let url = URL(string: APIKeys.webSocketBaseURL) {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            websocket = session.webSocketTask(with: url)
            websocket?.resume()
            
            ping()
        }
    }
    
    func closeWebSocket() {
        websocket?.cancel(with: .goingAway, reason: nil)
        websocket = nil
        
        timer?.invalidate()
        timer = nil
        
        isOpen = false
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Socket Open")
        isOpen = true
        
        receiveSocketData()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Socket Close")
        isOpen = false
    }
}

extension WebSocketManager {
    func send(_ string: String) {
        websocket?.send(.string(string)) { error in
            print("Send Error")
        }
    }
    
    func receiveSocketData() {
        if isOpen {
            websocket?.receive(completionHandler: { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let success):
                    switch success {
                    case .data(let data):
                        do {
                            let decodedData = try JSONDecoder().decode(Ticker.self, from: data)
                             print(decodedData)
                            tickerSbj.send(decodedData)
                        } catch {
                            print("Decoding Error", error)
                        }
                    case .string(let string):
                        print(string)
                    @unknown default:
                        print("Unknown Default")
                    }
                case .failure(let failure):
                    print("failure", failure)
                }
                receiveSocketData()
            })
        }
    }
    
    func ping() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            websocket?.sendPing(pongReceiveHandler: { error in
                if let error = error {
                    print("ping pong error", error.localizedDescription)
                } else {
                    print("ping ping ping")
                }
            })
        })
    }
}
