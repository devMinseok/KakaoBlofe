//
//  AppFlow.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

final class AppFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController = UINavigationController()
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BlofeStep else { return .none }
        
        switch step {
        case .homeIsRequired:
            return navigateToHome()
        }
    }
    
}

// MARK: - Navigate Code
extension AppFlow {
    private func navigateToHome() -> FlowContributors {
        let reactor = HomeViewReactor()
        let viewController = HomeViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}