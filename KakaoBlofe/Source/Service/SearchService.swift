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

protocol SearchServiceProtocol {
    func searchBlog(query: String,sort: SortType , page: Int, size: Int) -> Single<List<Blog>>
    
    func searchCafe(query: String, sort: SortType, page: Int, size: Int) -> Single<List<Cafe>>
}

final class SearchService: SearchServiceProtocol {
    private let network: Network<KakaoAPI>
    
    init(network: Network<KakaoAPI>) {
        self.network = network
    }
    
    func searchBlog(query: String, sort: SortType, page: Int, size: Int) -> Single<List<Blog>> {
        var sortType = ""
        switch sort {
        case .accuracy:
            sortType = "accuracy"
        case .recency:
            sortType = "recency"
        }

        return self.network.requestObject(.searchBlog(query, sortType, page, size), type: List<Blog>.self)
    }
    
    func searchCafe(query: String, sort: SortType, page: Int, size: Int) -> Single<List<Cafe>> {
        var sortType = ""
        switch sort {
        case .accuracy:
            sortType = "accuracy"
        case .recency:
            sortType = "recency"
        }

        return self.network.requestObject(.searchCafe(query, sortType, page, size), type: List<Cafe>.self)
    }
}
