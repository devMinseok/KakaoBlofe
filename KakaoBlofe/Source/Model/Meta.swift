//
//  Meta.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Foundation

struct Meta: Codable {
    var isEnd: Bool
    var pageableCount: Int
    var totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
