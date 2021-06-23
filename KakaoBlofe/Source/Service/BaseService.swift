//
//  BaseService.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/23.
//

import Foundation

class BaseService {
    unowned let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
}
