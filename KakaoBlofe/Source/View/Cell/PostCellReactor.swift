//
//  PostCellReactor.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import ReactorKit

final class PostCellReactor: Reactor {
    
    enum Action {
        case checkWebPageRead(URL)
    }
    
    enum Mutation {
        case setIsWebPageRead(Bool)
    }
    
    struct State {
        var isWebPageRead: Bool
        
        let thumbnail: URL?
        let name: String
        let title: String
        let date: Date
        let kind: PostKind
        let url: URL
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let urlEventMutation = self.provider.searchService.urlEvent
            .map { urls in
                Mutation.setIsWebPageRead(urls.contains(self.currentState.url.absoluteString))
            }

        return Observable.merge(mutation, urlEventMutation)
    }
    
    var initialState: State
    let provider: ServiceProviderType
    
    init(
        post: Post,
        provider: ServiceProviderType
    ) {
        self.provider = provider
        
        self.initialState = State(
            isWebPageRead: provider.searchService.isCheckedURL(url: post.url),
            thumbnail: post.thumbnail,
            name: post.name,
            title: post.title,
            date: post.dateTime,
            kind: post.kind,
            url: post.url
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .checkWebPageRead(url):
            return .just(.setIsWebPageRead(self.currentState.url == url))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setIsWebPageRead(isWebPageRead):
            state.isWebPageRead = isWebPageRead
        }
        
        return state
    }
}
