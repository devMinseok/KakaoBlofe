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

extension HomeViewSection: SectionModelType, Equatable {
    static func == (lhs: HomeViewSection, rhs: HomeViewSection) -> Bool {
        return lhs.id == rhs.id
    }
    
    typealias Item = HomeViewSectionItem
    
    var id: UUID {
        return UUID()
    }
    
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
