//
//  CoingeckoAPI.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation
import Moya

enum CoingeckoAPI {
    case trending
}

extension CoingeckoAPI: TargetType {
    var baseURL: URL { URL(string: APIKeys.baseURL)! }
    
    var path: String {
        switch self {
        case .trending:
            return "/search/trending"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .trending:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .trending:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .trending:
            return nil
        }
    }
}
