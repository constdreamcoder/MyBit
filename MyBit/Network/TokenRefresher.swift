//
//  TokenRefresher.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/19/24.
//

import Foundation
import Alamofire

final class TokenRefresher: RequestInterceptor {
        
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let token = KeychainManager.read(key: .refreshToken)
        urlRequest.setValue(token, forHTTPHeaderField: Headers.refreshToken.rawValue)
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              (400...500) ~= response.statusCode
        else {
            completion(.doNotRetryWithError(error))
            return
        }
                
        // 여기에서 오류 코드에 따른 토큰 갱신을 위한 분기처리를 구현할 예정입니다!
        
    }
}

