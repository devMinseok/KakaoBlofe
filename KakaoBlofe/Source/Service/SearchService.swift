//
//  SearchService.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import RxSwift

enum SortType {
    case titleAsc
    case recency
}

enum FilterType {
    case cafe
    case blog
    case all
}

protocol SearchServiceType {
    func searchPost(query: String, filter: FilterType, sort: SortType, page: Int, size: Int) -> Single<List>
    
    func getSearchHistory() -> Observable<[String]>
    
    func setSearchHistory(histories: [String])
}

final class SearchService: BaseService, SearchServiceType {
    private var network: Network<KakaoAPI> = Network(plugins: [RequestLoggingPlugin()])
    
    var searchHistories: [String]? {
        return self.provider.userDefaultService.value(object: [String].self, forKey: "SearchHistory")
    }
    
    func getSearchHistory() -> Observable<[String]> {
        guard let histories = self.searchHistories else { return .empty() }
        return .just(histories)
    }
    
    func setSearchHistory(histories: [String]) {
        self.provider.userDefaultService.set(value: histories, forKey: "SearchHistory")
    }
    
    func searchBlog(query: String, page: Int, size: Int) -> Single<List> {
        return self.network.requestObject(.searchBlog(query, page, size), type: List.self)
    }
    
    func searchCafe(query: String, page: Int, size: Int) -> Single<List> {
        return self.network.requestObject(.searchCafe(query, page, size), type: List.self)
    }
    
    func searchPost(query: String, filter: FilterType, sort: SortType, page: Int, size: Int) -> Single<List> {
        switch filter {
        case .all:
            let size = size / 2
            let blog = self.searchBlog(query: query, page: page, size: size)
            let cafe = self.searchCafe(query: query, page: page, size: size)
            
            return Single.zip(blog, cafe) { lhs, rhs in
                var result = lhs.documents + rhs.documents
                switch sort {
                case .recency:
                    result.sort(by: { $0.dateTime > $1.dateTime })
                    
                case .titleAsc:
                    result.sort(by: { $0.title < $1.title })
                }
                
                let metaData = Meta(
                    isEnd: lhs.meta.isEnd || rhs.meta.isEnd,
                    pageableCount: lhs.meta.pageableCount + rhs.meta.pageableCount,
                    totalCount: lhs.meta.totalCount + rhs.meta.totalCount
                )
                
                return List(documents: result, meta: metaData)
            }
            
        case .blog:
            return self.searchBlog(query: query, page: page, size: size)
                .map { list in
                    var result = list.documents
                    switch sort {
                    case .recency:
                        result.sort(by: { $0.dateTime > $1.dateTime })
                        
                    case .titleAsc:
                        result.sort(by: { $0.title < $1.title })
                    }
                    
                    return List(documents: result, meta: list.meta)
                }
            
        case .cafe:
            return self.searchCafe(query: query, page: page, size: size)
                .map { list in
                    var result = list.documents
                    switch sort {
                    case .recency:
                        result.sort(by: { $0.dateTime > $1.dateTime })
                        
                    case .titleAsc:
                        result.sort(by: { $0.title < $1.title })
                    }
                    
                    return List(documents: result, meta: list.meta)
                }
        }
    }
}
