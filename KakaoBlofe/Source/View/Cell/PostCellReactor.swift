//
//  PostCellReactor.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import ReactorKit

final class PostCellReactor: Reactor {
    
    enum Action {
        
    }
    
    struct State {
        let thumbnail: URL?
        let name: String
        let title: String
        let date: Date
        let kind: PostKind
        var isWebPageRead: Bool
    }
    
    var initialState: State
    let post: Post
    
    init(post: Post) {
        self.post = post
        
        self.initialState = State(
            thumbnail: post.thumbnail,
            name: post.name,
            title: post.title,
            date: post.dateTime,
            kind: post.kind,
            isWebPageRead: post.isWebPageRead
        )
    }
}
