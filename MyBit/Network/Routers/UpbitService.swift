//
//  UpbitService.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/8/24.
//

import Foundation
import Moya

enum UpbitService {
    case marketCodes
    case currentPrices(marketCodes: String)
}

extension UpbitService: TargetType {
    var baseURL: URL { URL(string: APIKeys.realtimeCoinBaseURL)! }
    
    var path: String {
        switch self {
        case .marketCodes:
            return "/market/all"
        case .currentPrices:
            return "/ticker"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .marketCodes, .currentPrices:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .marketCodes:
            return .requestParameters(parameters: ["isDetails": "false"], encoding: URLEncoding.queryString)
        case .currentPrices(let marketCodes):
            return .requestParameters(parameters: ["markets": marketCodes], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

