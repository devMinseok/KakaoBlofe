//
//  ServiceProvider.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/23.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var userDefaultService: UserDefaultServiceType { get }
    var searchService: SearchServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var userDefaultService: UserDefaultServiceType = UserDefaultService(provider: self)
    lazy var searchService: SearchServiceType = SearchService(provider: self)
}
