# MyBit - 실시간 코인 시세 조회 앱

<p>
    <img src="https://github.com/constdreamcoder/Beer/assets/95998675/56def750-b62c-4173-9a6c-e89d355e45c7" width="100%"/>
</p>

<br/>

## MyBit

- 서비스 소개: 실시간 코인 시세 조회 앱
- 개발 인원: 1인
- 개발 기간: 24.06.05 ~ 24.06.17(총 13일)
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

## 💻 기술 적용
- **MVI** 패턴을 통해 각 구성 요소의 커스텀 프로토콜 구성을 통한 역할을 분리와 각 화면별 단방향 데이터 흐름 구성
- **PluginType** 프로토콜 준수하는 **Plugin** 구성으로 네트워크 Logging 구현
- **Interceptor**를 활용한 토큰 갱신 로직 구성
- **WebSocket**을 활용한 실시간 소켓 통신 로직 구축
- **Realm**의 **Repository** 패턴 구성으로 데이터 접근 로직 추상화
- **Custom Property Wrapper**를 활용한 **Keychain** 관리 로직 추상화
- **Kingfisher**에서 토큰을 활용한 외부 이미지 다운로드 로직 모듈화
- **DGCharts** 라이브러리를 활용한 차트 구현으로 iOS15 버전 대응
- **NWPathMonitor**를 활용한 실시간 네트워크 연결 상태  모니터링 구축
- **AuthenticationServices**와 **KakaoOpenSDK**를 통한 소셜 로그인 구현(**애플/카카오**)

<br/>

## 💾 구현 내용

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

[👉 SwiftUI에서 네트워크 단절 대응 블로그 링크](https://picelworld.tistory.com/79)

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

<img src="https://github.com/constdreamcoder/MediaProject/assets/95998675/3c10d3e3-76a6-43ee-90aa-b8c02ba615a6" align="center" width="200">

<br/>

## 🔥 트러블 슈팅

### 1. 오류 코드 네트워크 응답 Body 수신에 따른 JWT 갱신

문제상황

- 오류 코드가 Status Code가 아닌 네트워크 응답 Body에 수신되어 RequestInterceptor 프르토콜에서 JWT 갱신을 위한 오류 코드 구분이 어려움

    <img src="https://github.com/constdreamcoder/TodoList/assets/95998675/6a0af3fc-70cb-4770-a781-1380cfe99135">

<br/>

문제 원인 파악

- RequestInterceptor 프로토콜에서 네트워크 응답에 접근하는 request 파라미터의 response 타입이 HTTPURLResponse이기 때문에, RequestInterceptor 프로토콜 메서드로 내에서 네트워크 응답 Body에 직접 접근 불가

<br/>

해결방법

- RequestInterceptor 프로토콜의 request 파라미터를 통해 다시 네트워크 요청을 보내어 오류 코드에 접근

    <img src="https://github.com/constdreamcoder/TodoList/assets/95998675/888582cf-6359-40e1-9d9c-bafdcf0b6617">

<br/>

### 2. SwiftUI 버전 대응 - Chart

문제상황

- 프로젝트 타겟 최소 버전이 iOS15로 설정되어 iOS16부터 사용 가능한 SwiftUI의 Charts 프레임워크를 사용 불가

<br/>

문제 원인 파악

- 타겟 최소 버전이 iOS15에 맞는 라이브러리 필요

<br/>

해결방법

- UIKit 기반 DGCharts 라이브러리 도입 및 UIViewRepresentable을 사용하여 ChartView 구현

  ```swift
  import DGCharts
  import SwiftUI

  struct ChartView: UIViewRepresentable {

      let entries: [ChartDataEntry]

      func makeUIView(context: Context) -> LineChartView {
          // ChartView 정의
      }

      func updateUIView(_ uiView: LineChartView, context: Context) {
          // ChartView 업데이트
      }
  }

  ```
