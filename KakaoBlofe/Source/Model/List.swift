//
//  List.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Foundation

struct List: Codable {
    var documents: [Post]
    var meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case documents
        case meta
    }
}
