//
//  Post.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import Foundation

enum PostKind {
    case blog
    case cafe
}

struct Post: Codable {
    var cafeName: String?
    var blogName: String?
    var contents: String
    var dateTime: Date
    var thumbnail: URL?
    var title: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case cafeName = "cafename"
        case blogName = "blogname"
        case contents
        case dateTime = "datetime"
        case thumbnail
        case title
        case url
    }
    
    var name: String {
        if let name = cafeName {
            return name
        } else if let name = blogName {
            return name
        } else {
            return ""
        }
    }
    
    var kind: PostKind {
        if cafeName != nil {
            return .cafe
        } else {
            return .blog
        }
    }
    
    var isWebPageRead: Bool = false
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cafeName = try? values.decode(String.self, forKey: .cafeName)
        blogName = try? values.decode(String.self, forKey: .blogName)
        contents = try values.decode(String.self, forKey: .contents)
        dateTime = try values.decode(Date.self, forKey: .dateTime)
        thumbnail = try? values.decode(URL.self, forKey: .thumbnail)
        title = try values.decode(String.self, forKey: .title)
        url = try values.decode(URL.self, forKey: .url)
    }
}
