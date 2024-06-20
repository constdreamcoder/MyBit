//
//  TokenRefresher.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/19/24.
//

import Foundation
import Alamofire
import Combine

final class TokenRefresher: RequestInterceptor {
    
    private var cancelable = Set<AnyCancellable>()

        
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
      
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              (400...500) ~= response.statusCode
        else {
            completion(.doNotRetryWithError(error))
            return
        }
                
        guard let request = request.request else {
            completion(.doNotRetryWithError(error))
            return
        }
    
        AF.request(request)
            .validate(statusCode: (400...500))
            .responseDecodable(of: ErrorCode.self) { [weak self] response in
                guard let self else { return }

                switch response.result {
                case .success(let errorCode):
                    print("error code", errorCode.errorCode)
                    if errorCode.errorCode == "E05" {
                        UserManager.refreshToken()
                            .sink { complete in
                                if case .failure(let error) = complete {
                                    print("Fail to Refresh Token", error)
                                    completion(.doNotRetryWithError(error))
                                }
                            } receiveValue: { refreshedToken in
                                print("success")
                                KeychainManager.create(key: .accessToken, value: refreshedToken.accessToken)
                                completion(.retry)
                            }
                            .store(in: &cancelable)
                    
                    }
                case .failure(let failure):
                    print("Network Connection Failure", failure)
                }
            }
            
    }
}

