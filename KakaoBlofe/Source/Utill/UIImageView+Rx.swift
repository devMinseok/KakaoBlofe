//
//  UIImageView+Rx.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/22.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift

extension Reactive where Base: UIImageView {
    func image(placeholder: UIImage? = nil) -> Binder<Resource?> {
        return Binder(self.base) { imageView, resource in
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: resource, placeholder: placeholder)
        }
    }
}
