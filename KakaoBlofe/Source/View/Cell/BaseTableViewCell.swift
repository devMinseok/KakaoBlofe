//
//  BaseTableViewCell.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import UIKit

import RxSwift

class BaseTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .default, reuseIdentifier: nil)
    }
}
