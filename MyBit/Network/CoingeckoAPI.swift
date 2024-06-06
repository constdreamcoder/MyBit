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
    case search(query: String)
}

extension CoingeckoAPI: TargetType {
    var baseURL: URL { URL(string: APIKeys.baseURL)! }
    
    var path: String {
        switch self {
        case .trending:
            return "/search/trending"
        case .search:
            return "/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .trending, .search:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .trending:
            return .requestPlain
        case .search(let query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .trending, .search:
            return nil
        }
    }
}
