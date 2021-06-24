//
//  FilterHeaderView.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/23.
//

import UIKit

final class FilterHeaderView: UIView {
    let filterButton = UIButton().then {
        $0.setTitle("ALL", for: .normal)
    }
    
    let sortButton = UIButton().then {
        $0.setImage(UIImage(named: "sortIcon"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.filterButton)
        self.addSubview(self.sortButton)
        
        self.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.filterButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalTo(self.sortButton.snp.left)
        }
        
        self.sortButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(self.frame.height)
        }
    }
}
