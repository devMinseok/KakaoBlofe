//
//  UserDefaultService.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/23.
//

import Foundation

protocol UserDefaultServiceType {
    func value<T>(object: T.Type, forKey key: String) -> T?
    
    func set<T>(value: T?, forKey key: String)
}

final class UserDefaultService: BaseService, UserDefaultServiceType {
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    func value<T>(object: T.Type, forKey key: String) -> T? {
        return self.defaults.value(forKey: key) as? T
    }
    
    func set<T>(value: T?, forKey key: String) {
        self.defaults.set(value, forKey: key)
        self.defaults.synchronize()
    }
}
