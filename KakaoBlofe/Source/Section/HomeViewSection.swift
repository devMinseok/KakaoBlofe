//
//  HomeViewSection.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import RxDataSources

enum HomeViewSection {
    case postSection([HomeViewSectionItem])
}

extension HomeViewSection: SectionModelType {
    typealias Item = HomeViewSectionItem
    
    var items: [HomeViewSectionItem] {
        switch self {
        case let .postSection(items):
            return items
        }
    }
    
    init(original: HomeViewSection, items: [HomeViewSectionItem]) {
        switch original {
        case .postSection:
            self = .postSection(items)
        }
    }
    
}

enum HomeViewSectionItem {
    case postItem(PostCellReactor)
}
