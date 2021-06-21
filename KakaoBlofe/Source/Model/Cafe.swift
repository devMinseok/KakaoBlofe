//
//  Cafe.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Foundation

struct Cafe: Codable {
    var cafeName: String
    var contents: String
    var dateTime: Date
    var thumbnail: URL
    var title: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case cafeName = "cafename"
        case contents
        case dateTime = "datetime"
        case thumbnail
        case title
        case url
    }
}
