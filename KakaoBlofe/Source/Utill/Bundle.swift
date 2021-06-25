//
//  Bundle.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/25.
//

import Foundation

extension Bundle {
    class func jsonData(name: String) -> Data {
        guard let url = self.main.url(forResource: name, withExtension: "json") else { return Data() }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return Data()
        }
    }
}
