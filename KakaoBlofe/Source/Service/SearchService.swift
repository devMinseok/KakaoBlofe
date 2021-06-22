//
//  SearchService.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import RxSwift

enum SortType {
    case accuracy
    case recency
}

protocol SearchServiceType {
    func searchBlog(query: String,sort: SortType , page: Int, size: Int) -> Single<List<Post>>
    
    func searchCafe(query: String, sort: SortType, page: Int, size: Int) -> Single<List<Post>>
}

final class SearchService: SearchServiceType {
    private let network: Network<KakaoAPI>
    
    init(network: Network<KakaoAPI>) {
        self.network = network
    }
    
    func searchBlog(query: String, sort: SortType, page: Int, size: Int) -> Single<List<Post>> {
        var sortType = ""
        switch sort {
        case .accuracy:
            sortType = "accuracy"
        case .recency:
            sortType = "recency"
        }

        return self.network.requestObject(.searchBlog(query, sortType, page, size), type: List<Post>.self)
    }
    
    func searchCafe(query: String, sort: SortType, page: Int, size: Int) -> Single<List<Post>> {
        var sortType = ""
        switch sort {
        case .accuracy:
            sortType = "accuracy"
        case .recency:
            sortType = "recency"
        }

        return self.network.requestObject(.searchCafe(query, sortType, page, size), type: List<Post>.self)
    }
}
