//
//  HomeViewReactor.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class HomeViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case refresh
        case loadMore
        case postSelected(Post)
    }

    enum Mutation {
        case setLoading(Bool)
        case setPosts([Post])
        case appendPosts([Post])
    }

    struct State {
        var section: [HomeViewSection] = [.postSection([])]
        
        var page: Int = 0
        var query: String = ""
        
        var isLoading: Bool = false
    }

    let initialState: State = State()
    private let searchService: SearchServiceType
    
    private let errorRelay = PublishRelay<ErrorResponse?>()
    lazy var error = errorRelay.asObservable()

    init(searchService: SearchServiceType) {
        self.searchService = searchService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let startLoading = Observable.just(Mutation.setLoading(true))
            let stopLoading = Observable.just(Mutation.setLoading(false))
            let search = self.searchService.searchBlog(query: "iOS", sort: .accuracy, page: 1, size: 25)
                .asObservable()
                .map { list in
                    return Mutation.setPosts(list.documents)
                }
                .catchError { error in
                    self.errorRelay.accept(error as? ErrorResponse)
                    return .empty()
                }
            
            return .concat([startLoading, search, stopLoading])
            
        case .loadMore:
            let startLoading = Observable.just(Mutation.setLoading(true))
            let stopLoading = Observable.just(Mutation.setLoading(false))
            let search = self.searchService.searchBlog(query: "iOS", sort: .accuracy, page: self.currentState.page, size: 25)
                .asObservable()
                .map { list in
                    return Mutation.appendPosts(list.documents)
                }
                .catchError { error in
                    self.errorRelay.accept(error as? ErrorResponse)
                    return .empty()
                }
            
            return .concat([startLoading, search, stopLoading])
            
        case let .postSelected(post):
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .setPosts(posts):
            let sectionItems = self.postSectionItems(with: posts)
            state.section = [.postSection(sectionItems)]
            state.page = 2
            
        case let .appendPosts(posts):
            let sectionItems = state.section[0].items + self.postSectionItems(with: posts)
            state.section = [.postSection(sectionItems)]
            state.page += 1
        }

        return state
    }
    
    private func postSectionItems(with posts: [Post]) -> [HomeViewSectionItem] {
        var sectionItems = [HomeViewSectionItem]()
        
        posts.forEach { post in
            sectionItems.append(.postItem(PostCellReactor(post: post)))
        }
        
        return sectionItems
    }
}
