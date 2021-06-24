//
//  UIScrollView+Rx.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIScrollView {
    var isReachedBottom: ControlEvent<Void> {
        let source = self.contentOffset
            .filter { [weak base = self.base] offset in
                guard let base = base else { return false }
                return base.isReachedBottom(tableViewContentSize: base.contentSize.height)
            }
            .map { _ in Void() }
        
        return ControlEvent(events: source)
    }
}
