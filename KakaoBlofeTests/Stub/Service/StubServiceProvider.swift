//
//  StubServiceProvider.swift
//  KakaoBlofeTests
//
//  Created by 강민석 on 2021/06/25.
//

@testable import KakaoBlofe

final class StubServiceProvider: ServiceProviderType {
    lazy var userDefaultService: UserDefaultServiceType = StubUserDefaultService()
    lazy var searchService: SearchServiceType = SearchService(provider: self, isStub: true)
}
