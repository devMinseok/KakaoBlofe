//
//  UITableView+Rx.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UITableView {
    var deselectRow: Binder<IndexPath> {
        return Binder(self.base) { tableView, indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
