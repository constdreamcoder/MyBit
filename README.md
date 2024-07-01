# MyBit - 실시간 코인 시세 조회 앱

<p>
    <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/b854d0e1-0e53-446f-901d-05eb958de02e" align="center" width="100%"/>
</p>

<br/>

## MyBit

- 서비스 소개: 실시간으로 코인 시세를 조회할 수 있는 앱입니다.
- 개발 인원: 1인
- 개발 기간: 24.06.05 ~ 24.06.17(총 12일)
- 개발 환경
  - 최소버전: iOS 15
  - Portrait Orientation 지원
  - 라이트 모드 지원

<br/>

## 💪 주요 기능

- 회원 인증: 회원 가입 / 로그인 / 로그아웃
- 소셜 로그인: 카카오톡 로그인 / 애플 로그인
- 프로필 조회 / 수정
- 코인 관련 기능
  - 코인 랭킹 기능
  - 코인 검색 / 조회 기능
  - 실시간 코인 시세 변동 조회 기능
  - 코인 즐겨찾기 기능

<br/>

## 🛠 기술 소개

- MVI
- SwiftUI, Combine
- Moya, Alamofire, WebSocket, KakaoOpenSDK
- Kingfisher, DGCharts, Realm, Keychain

<br/>

## 💻 구현 내용

### 1. 소셜 로그인

- AuthenticationServices를 이용한 애플 소셜 로그인 구현

  [👉 애플 소셜 로그인 블로그 링크](https://picelworld.tistory.com/73)

- KakaoSDK를 이용한 카카오 소셜 로그인 구현

  [👉 카카오 소셜 로그인 블로그 링크](https://picelworld.tistory.com/72)

<br/>

### 2. WebSocket을 활용한 실시간 코인 시세 변동 조회 구현

[👉 Socket 구현 블로그 링크](https://picelworld.tistory.com/46)

<details>
<summary><b>코드</b></summary>
<div markdown="1">

```swift
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

```

</div>
</details>

<br/>

<img src="https://github.com/constdreamcoder/TodoList/assets/95998675/6870c379-bc45-4620-bcb9-a9e6b230a9cb" align="center" width="200">

<br/>

### 3. Keychain을 활용한 Custom Property Wrapper 정의

[👉 Keychain 구현 블로그 링크](https://picelworld.tistory.com/71)

- Keychain Manager 정의

  ```swift
  struct KeychainManager {

      enum Key: String, CaseIterable {
          case profileImage = "profileImage"
          // ...
      }

      // Keychain 생성
      static func create(key: Key, value: String) {
        // ...
      }

      // Keychain 조회
      static func read(key: Key) -> String? {
        // ...
      }

      // Keychain 삭제
      static func delete(key: Key) {
        // ...
      }
  }
  ```

- Custom Property Wrapper 정의

  ```swift
  @propertyWrapper
  struct KeychainStorage: DynamicProperty {

      private let key: KeychainManager.Key
      @State private var data: String

      var wrappedValue: String {
          get {
             // getter 정의
          }
          nonmutating set {
             // setter 정의
          }
      }

      var projectedValue: Binding<String> {
          // projectedValue 정의
      }

      init(wrappedValue: String, _ key: KeychainManager.Key) {
          self.key = key
          if let data = KeychainManager.read(key: key) {
              self.data = data
          } else {
              self.data = wrappedValue
          }
      }
  }
  ```

<br/>

### 4. 네트워크 연결 단절 대응

<details>
<summary><b>코드</b></summary>
<div markdown="1">

```swift
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
```

</div>
</details>

<br/>

[👉 SwiftUI에서 네트워크 단절 대응 블로그 링크](https://picelworld.tistory.com/79)

<img src="https://github.com/constdreamcoder/MediaProject/assets/95998675/3c10d3e3-76a6-43ee-90aa-b8c02ba615a6" align="center" width="200">

<br/>

## 🔥 트러블 슈팅

### 1. 네트워크 오류 코드에 따른 JWT 갱신

문제상황

문제 원인 파악

해결방법

### 2. Chart 버전 대응

문제상황

문제 원인 파악

해결방법
