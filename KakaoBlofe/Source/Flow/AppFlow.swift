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
import SafariServices

final class AppFlow: Flow {
    private let provider: ServiceProviderType
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController = UINavigationController()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BlofeStep else { return .none }
        
        switch step {
        case .homeIsRequired:
            return navigateToHome()
            
        case let .postDetailIsRequired(post):
            return navigateToPostDetail(post: post)
            
        case let .urlPageIsRequired(url):
            return navigateToURLPage(url: url)
        }
    }
}

// MARK: - Navigate Code
extension AppFlow {
    private func navigateToHome() -> FlowContributors {
        let reactor = HomeViewReactor(provider: self.provider)
        let viewController = HomeViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPostDetail(post: Post) -> FlowContributors {
        let reactor = PostDetailViewReactor(post: post, provider: self.provider)
        let viewController = PostDetailViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToURLPage(url: URL) -> FlowContributors {
        let viewController = SFSafariViewController(url: url)
        
        self.rootViewController.present(viewController, animated: true)
        return .none
    }
}
