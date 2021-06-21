//
//  Blog.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Foundation

struct Blog: Codable {
    var blogName: String
    var contents: String
    var dateTime: Date
    var thumbnail: URL
    var title: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case blogName = "blogname"
        case contents
        case dateTime = "datetime"
        case thumbnail
        case title
        case url
    }
}
