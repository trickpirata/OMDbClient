//
//  GPAPI.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/11/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import Foundation
import Moya

struct CONFIG {
    static let API = "http://www.omdbapi.com"
    static let API_KEY = "5b237b7e"
}

enum GPAPI {
    case search(query: String, page: Int)
    case searchForID(id: String)
}

extension GPAPI: TargetType {
    var baseURL: URL {
        return URL(string: CONFIG.API)!
    }
    var path: String {
        switch self {
        case .search,
             .searchForID:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search,
             .searchForID:
            return .get
        }
        
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .search(query: let query,page: let page):
            return .requestParameters(parameters: ["s": query, "page": page, "apikey": CONFIG.API_KEY], encoding: URLEncoding.default)
        case .searchForID(id: let id):
            return .requestParameters(parameters: ["i": id, "apikey": CONFIG.API_KEY, "plot": "full"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .none
    }
}


public func url(route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

let endpointClosure = { (target: GPAPI) -> Endpoint in
    let defaultEndpoint = MoyaProvider<GPAPI>.defaultEndpointMapping(for: target)
    switch target {
    case .search,
         .searchForID:
        return defaultEndpoint
    }
}

let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
    var request = try! endpoint.urlRequest() as URLRequest
    done(.success(request))
}
 
private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}
