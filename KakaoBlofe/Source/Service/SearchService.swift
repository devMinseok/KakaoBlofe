//
//  SearchService.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import RxSwift

enum FilterType {
    case cafe
    case blog
    case all
}

protocol SearchServiceType {
    func searchPost(query: String, filter: FilterType, page: Int, size: Int) -> Single<List>
    
    func getSearchHistory() -> Observable<[String]>
    
    func setSearchHistory(histories: [String])
    
    var urlEvent: PublishSubject<[String]> { get }
    
    func setCheckedURL(url: URL)
    
    func refreshUrlEvent()
    
    func isCheckedURL(url: URL) -> Bool
}

final class SearchService: BaseService, SearchServiceType {
    
    private var network: Network<KakaoAPI>
    
    init(
        provider: ServiceProviderType,
        isStub: Bool
    ) {
        self.network = Network(plugins: [RequestLoggingPlugin()], isStub: isStub)
        super.init(provider: provider)
    }
    
    override convenience init(provider: ServiceProviderType) {
        self.init(provider: provider, isStub: false)
    }

    var searchHistories: [String]? {
        return self.provider.userDefaultService.value(object: [String].self, forKey: "SearchHistory")
    }
    
    var readURLs: [String]? {
        return self.provider.userDefaultService.value(object: [String].self, forKey: "readURLs")
    }
    
    func searchBlog(query: String, page: Int, size: Int) -> Single<List> {
        return self.network.requestObject(.searchBlog(query, page, size), type: List.self)
    }
    
    func searchCafe(query: String, page: Int, size: Int) -> Single<List> {
        return self.network.requestObject(.searchCafe(query, page, size), type: List.self)
    }
    
    
    let urlEvent = PublishSubject<[String]>()
    
    func isCheckedURL(url: URL) -> Bool {
        let url = url.absoluteString
        let urls = self.readURLs ?? [""]
        return urls.contains(url)
    }
    
    func setCheckedURL(url: URL) {
        var urls = self.readURLs ?? [""]
        urls.append(url.absoluteString)
        
        self.provider.userDefaultService.set(value: Array(Set(urls)), forKey: "readURLs")
        self.urlEvent.onNext(urls)
    }
    
    func refreshUrlEvent() {
        let urls = self.readURLs ?? [""]
        self.urlEvent.onNext(urls)
    }
    
    func getSearchHistory() -> Observable<[String]> {
        guard let histories = self.searchHistories else { return .empty() }
        return .just(histories)
    }
    
    func setSearchHistory(histories: [String]) {
        self.provider.userDefaultService.set(value: histories, forKey: "SearchHistory")
    }
    
    func searchPost(query: String, filter: FilterType, page: Int, size: Int) -> Single<List> {
        switch filter {
        case .all:
            let size = size / 2
            let blog = self.searchBlog(query: query, page: page, size: size)
            let cafe = self.searchCafe(query: query, page: page, size: size)
            
            return Single.zip(blog, cafe) { lhs, rhs in
                let documents = lhs.documents + rhs.documents
                let meta = Meta(
                    isEnd: lhs.meta.isEnd || rhs.meta.isEnd,
                    pageableCount: lhs.meta.pageableCount + rhs.meta.pageableCount,
                    totalCount: lhs.meta.totalCount + rhs.meta.totalCount
                )
                return List(documents: documents, meta: meta)
            }
            
        case .blog:
            return self.searchBlog(query: query, page: page, size: size)
            
        case .cafe:
            return self.searchCafe(query: query, page: page, size: size)
        }
    }
}
