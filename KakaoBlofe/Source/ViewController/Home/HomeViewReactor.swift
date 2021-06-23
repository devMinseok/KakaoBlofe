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
        case updateSearchWord(String)
        case loadSearchHistory
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setPosts([Post])
        case appendPosts([Post], Bool)
        case setSearchWord(String)
        case setSearchHistories([String])
        case setSearchHistory(String)
    }

    struct State {
        var section: [HomeViewSection] = [.postSection([])]
        
        var query: String = ""
        var page: Int = 0
        var isPageEnd: Bool = false
        var filterType: FilterType = .all
        var sortType: SortType = .titleAsc
        
        var searchHistory: [String] = [""]
        
        var isLoading: Bool = false
        var isRefreshing: Bool = false
    }

    let initialState: State = State()
    private let provider: ServiceProviderType
    
    private let errorRelay = PublishRelay<ErrorResponse?>()
    lazy var error = errorRelay.asObservable()

    init(provider: ServiceProviderType) {
        self.provider = provider
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            if self.currentState.isRefreshing { return .empty() }
            if self.currentState.isLoading { return .empty() }
            
            let startRefreshing = Observable.just(Mutation.setRefreshing(true))
            let stopRefreshing = Observable.just(Mutation.setRefreshing(false))
            let searchHistory = Observable.just(Mutation.setSearchHistory(self.currentState.query))
            
            let search = self.provider.searchService.searchPost(
                query: self.currentState.query,
                filter: self.currentState.filterType,
                sort: self.currentState.sortType,
                page: 1,
                size: 25
            )
            .asObservable()
            .map { list in
                return Mutation.setPosts(list.documents)
            }
            .catchError { error in
                self.errorRelay.accept(error as? ErrorResponse)
                return .empty()
            }
            
            return .concat([startRefreshing, search, stopRefreshing, searchHistory])
            
        case .loadMore:
            if self.currentState.isRefreshing { return .empty() }
            if self.currentState.isLoading { return .empty() }
            if self.currentState.isPageEnd { return .empty() }
            
            let startLoading = Observable.just(Mutation.setLoading(true))
            let stopLoading = Observable.just(Mutation.setLoading(false))
            
            let search = self.provider.searchService.searchPost(
                query: self.currentState.query,
                filter: self.currentState.filterType,
                sort: self.currentState.sortType,
                page: self.currentState.page,
                size: 25
            )
            .asObservable()
            .map { list in
                return Mutation.appendPosts(list.documents, list.meta.isEnd)
            }
            .catchError { error in
                self.errorRelay.accept(error as? ErrorResponse)
                return .empty()
            }
            
            return .concat([startLoading, search, stopLoading])
            
        case let .postSelected(post):
//            self.steps.accept(BlofeStep.postDetailIsRequired(post: post))
            return .empty()
            
        case let .updateSearchWord(keyword):
            return .just(.setSearchWord(keyword.trimmingCharacters(in: .whitespacesAndNewlines)))
            
        case .loadSearchHistory:
            return self.provider.searchService.getSearchHistory()
                .map { histories -> Mutation in
                    Mutation.setSearchHistories(histories)
                }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
            
        case let .setPosts(posts):
            state.isPageEnd = false
            let sectionItems = self.postSectionItems(with: posts)
            state.section = [.postSection(sectionItems)]
            state.page = 2
            
        case let .appendPosts(posts, isEnd):
            state.isPageEnd = isEnd
            let sectionItems = state.section[0].items + self.postSectionItems(with: posts)
            state.section = [.postSection(sectionItems)]
            state.page += 1
            
        case let .setSearchWord(keyword):
            state.query = keyword
            
        case let .setSearchHistories(histories):
            state.searchHistory = histories
            
        case let .setSearchHistory(history):
            if state.searchHistory.contains(history) {
                state.searchHistory.removeAll(where: { $0 == history || $0 == "" })
                state.searchHistory.append(history)
            } else {
                state.searchHistory.removeAll(where: { $0 == "" })
                state.searchHistory.append(history)
            }
            
            self.provider.searchService.setSearchHistory(histories: state.searchHistory)
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
