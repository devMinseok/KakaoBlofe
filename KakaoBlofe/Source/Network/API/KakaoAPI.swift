//
//  KakaoAPI.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Moya

enum KakaoAPI {
    case searchBlog(_ query: String, _ sort: String, _ page: Int, _ size: Int)
    case searchCafe(_ query: String, _ sort: String, _ page: Int, _ size: Int)
}

extension KakaoAPI: BaseAPI {
    var path: String {
        switch self {
        case .searchBlog:
            return "/v2/search/blog"
            
        case .searchCafe:
            return "/v2/search/cafe"
        }
    }
    
    var method: Method {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [String : String]? {
        ["Authorization": "KakaoAK 748e5d544b7c32a9b2b1a4b1a515edd6"]
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .searchBlog(query, sort, page, size):
            return [
                "query": query,
                "sort": sort,
                "page": page,
                "size": size
            ]
            
        case let .searchCafe(query, sort, page, size):
            return [
                "query": query,
                "sort": sort,
                "page": page,
                "size": size
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.queryString
        }
    }
    
    var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }
}
