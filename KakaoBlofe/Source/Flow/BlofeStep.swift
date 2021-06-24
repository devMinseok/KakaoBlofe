//
//  BlofeStep.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import RxFlow

enum BlofeStep: Step {
    case homeIsRequired
    case postDetailIsRequired(post: Post)
    case urlPageIsRequired(url: URL)
}
