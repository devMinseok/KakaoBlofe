//
//  UIScrollView.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import UIKit

extension UIScrollView {
    func isReachedBottom(tableViewContentSize: CGFloat) -> Bool {
        let contentOffsetY = self.contentOffset.y
        let paginationY = tableViewContentSize * 0.3
        
        return contentOffsetY > (tableViewContentSize - paginationY)
    }
}
