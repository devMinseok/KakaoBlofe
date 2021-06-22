//
//  RefreshControl.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import UIKit

final class RefreshControl: UIRefreshControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience override init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
