//
//  UITableView+Rx.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import RxCocoa
import RxSwift
import RxDataSources

extension Reactive where Base: UITableView {
    var deselectRow: Binder<IndexPath> {
        return Binder(self.base) { tableView, indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func itemSelected<T>(dataSource: RxTableViewSectionedReloadDataSource<T>) -> ControlEvent<T.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
}
