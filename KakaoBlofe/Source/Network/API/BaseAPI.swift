//
//  BaseAPI.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Moya

protocol BaseAPI: TargetType { }

extension BaseAPI {
    var baseURL: URL { URL(string: "https://dapi.kakao.com")! }
    
    var method: Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task { .requestPlain }
    
    var headers: [String : String]? { nil }
}
