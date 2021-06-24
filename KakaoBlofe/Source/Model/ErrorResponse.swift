//
//  ErrorResponse.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Foundation

struct ErrorResponse: Decodable, Error {
    var errorType: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case errorType
        case message
    }
}
