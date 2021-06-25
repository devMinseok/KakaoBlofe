//
//  StubUserDefaultService.swift
//  KakaoBlofeTests
//
//  Created by 강민석 on 2021/06/25.
//

@testable import KakaoBlofe

final class StubUserDefaultService: UserDefaultServiceType {
    var store = [String: Any]()
    
    func value<T>(object: T.Type, forKey key: String) -> T? {
        return self.store[key] as? T
    }
    
    func set<T>(value: T?, forKey key: String) {
        if let value = value {
            self.store[key] = value
        } else {
            self.store.removeValue(forKey: key)
        }
    }
}
