//
//  CoingeckoService.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import Foundation
import Moya

enum CoingeckoService {
    case trending
    case search(query: String)
    case coinMarket(currency: String = "krw", ids: String)
}

extension CoingeckoService: TargetType {
    var baseURL: URL { URL(string: APIKeys.baseURL)! }
    
    var path: String {
        switch self {
        case .trending:
            return "/search/trending"
        case .search:
            return "/search"
        case .coinMarket:
            return "/coins/markets"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .trending, .search, .coinMarket:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .trending:
            return .requestPlain
        case .search(let query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
        case .coinMarket(let currency, let ids):
            return .requestParameters(parameters: ["vs_currency": currency, "ids": ids, "sparkline": "true"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
